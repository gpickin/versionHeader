# Version Header

## Add App Version headers to your app in one module

This module determines the version of your app from a .version file and then creates a response header for you.

This module is ideal for clustered setups, or docker swarms, where the code could be running on one of many servers. This will allow you to know which version of the code your app is running.

## How does it work?

### Response Header

The module sets a header called `x-server-version`.

### When does it run?

The module listens to the onRequestCapture ColdBox interception point.

With Errors, this function might not run... if that interception point is not announced. You might need to add to your Application.cfc directly if errors occur before the ColdBox framework loads.

### How does it determine the Version?

This module looks for a file called `.version` 

### How do I build a .version file automatically?

With CI servers like GitLab, you can create the file with pipeline IDs and Job IDs so you can look up the build that created it.

```
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo "P${CI_PIPELINE_ID}-J${CI_JOB_ID} $TIMESTAMP" > ${CI_PROJECT_DIR}/.version
```

You can also use CommandBox with package scripts. When you run the command `bump --patch` commandbox will up the version in the box.json file, echo this version to the `.version` file and tag your repo as well.

```
"scripts":{
    "postVersion":"echo 'v`package version`' > .version && git add .version && git commit -m 'update version'"
}
```
