#!/usr/bin/env bash
# shellcheck disable=SC1090,SC1091

# Set output file by environment variable
if [ -n "$PLANNING_OUTPUT_FILE" ]; then
    change_parameters
    OUTPUT_FILE=$PLANNING_OUTPUT_FILE
    echo "Output file: $OUTPUT_FILE"
elif [ -n "$SIMULATION_OUTPUT_DIRECTORY" ]; then
    OUTPUT_FILE=$SIMULATION_OUTPUT_DIRECTORY/scenario_test_runner/result.junit.xml
    echo "Output file: $OUTPUT_FILE"
else
    echo "Warning: No output file is set" >&2
fi

# Run the launch command
echo "Running: $@"
source "/opt/ros/$ROS_DISTRO/setup.bash"
source /autoware/install/setup.bash
"$@" &
ros_pid=$!

# Create output directory
mkdir -p /autoware/result

# Function to upload the output video to an S3 object
uploadToS3() {
    echo "Uploading output video to S3..."

    if [ -z "$AWS_BATCH_JOB_ARRAY_INDEX" ]; then
        S3_PREFIX="${AWS_BATCH_JOB_ID}"
    else
        S3_PREFIX="${AWS_BATCH_JOB_ID}_${AWS_BATCH_JOB_ARRAY_INDEX}"
    fi
    S3_OBJECT_KEY="${S3_PREFIX}/visu.mp4"
    echo "S3 object key: $S3_OBJECT_KEY"
    # Trim leading/trailing spaces from S3_BUCKET
    S3_BUCKET=$(echo "$S3_BUCKET" | xargs)

    FULL_S3_PATH="s3://${S3_BUCKET}/${S3_OBJECT_KEY}"
    echo "Full S3 path: $FULL_S3_PATH"

    # Upload the file to S3
    aws s3 cp ${OUTPUT_FILE} ${FULL_S3_PATH}

    echo "Upload completed."
}

# Function to handle termination
cleanup() {
    echo "Terminating processes..."
    kill $ros_pid
    wait $ros_pid
    echo "Processes terminated."

    # Call the uploadToS3 function
    if [ -n "$OUTPUT_FILE" ] && [ -f "$OUTPUT_FILE" ]; then
        uploadToS3
    else
        echo "Output file not found or not set. Skipping S3 upload."
    fi

    exit 0
}

# Set up trap to catch termination signal
trap cleanup SIGTERM SIGINT

# Wait for any process to exit
wait -n

# No process should exit. If one does, exit the script
exit 1
