iib verify
app_deploy_status =  null
    for dir in "$DEPLOY_DIR"/*/; do 
      app_name = $( basename "$dir" )
      if [ $app_deploy_status != "BARfiles" && $app_name != "GeneratedBarFiles" && $app_name != ".metadata" ] then
        app_deploy_status = $(mqsilist IIBNODE1 -e default -k $app_name)
        if [ $app_deploy_status == BIP1277I* ]; then 
          echo "$app_name could not be deployed successfully or is not running"
          exit 1;
        fi 
      fi
    done