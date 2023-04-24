# extract application names and deploy from repo to node in container
    BROKER_URL=IIBNODE1
    # BROKER_PORT=
    # BROKER_SECURITY=
    # BROKER_USERNAME=
    # BROKER_PASSWORD=
    # workspace directory necessary here
      DEPLOY_DIR=.
      for dir in "$DEPLOY_DIR"/*/; do 
      app_name=$(basename "$dir")
      if [ $app_name != "BARfiles" && $app_name != "GeneratedBarFiles" && $app_name != ".metadata" ] then
        bar_file="$DEPLOY_DIR/$app_name.bar"
        echo "Creating BAR file for $app_name..."
        mqsicreatebar -data "$DEPLOY_DIR" -b "$bar_file" -a "$app_name"
        mqsideploy $BROKER_URL -e default -a "$app_name".bar
      fi
      done