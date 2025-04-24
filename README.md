# Documentation

## azure login

First we need to login to azure, this is done with the `azure/login` action, you need to set up a secret called `AZURE_CREDENTIALS` in your github repo settings, 
what you need here is the output of the following command:

```bash
az ad sp create-for-rbac --name "github-terraform" --role="Contributor" --scopes="/subscriptions/<SUBSCRIPTION_ID>" --sdk-auth
```

You past this output in the secret, this will give you access to your azure account and allow you to create resources.

Remember to replace `<SUBSCRIPTION_ID>` with your subscription id, you can find it in the azure portal. Also, for further secretes, the secretes go with out: " "

We also need some other secretes for the workflow to work, we need to set up the following secretes in your github repo settings:
- `TF_VAR_USERNAME`: the username you want for the vms
- `TF_VAR_PASSWORD`: the password you want for the vms
- `ARM_CLIENT_ID`: the client id of the service principal you created
- `ARM_CLIENT_SECRET`: the client secret of the service principal you created
- `ARM_SUBSCRIPTION_ID`: the subscription id of the service principal you created
- `ARM_TENANT_ID`: the tenant id of the service principal you created

you'll find most of this information in the output of the command we ran before, but you can also find it in the azure portal.
You can always create more secrets for more users, but for now we are going to use the same user for all the vms.

## terraform

Now, terraform is still a bit tricky, let me explain: normally, terraform uses a file called `terraform.tfstate` to keep track of the resources it creates, 
this file is created in the same folder as the terraform files, however, if we push this file to github we'll have a 
big problem, as it contains information like your subscription id, client id, client secret and other sensitive information. 

This is where the tricky part comes in, we need to store it in a new location so that's safe. We can do this using the backend.tf file present.
However, this will cause a problem, as terraform will try to create the backend BEFORE creating the resource where will store the state file, and
we can't use dynamic naming in the naming file. My recommendation is to remove the backend.tf temporarily, run the workflow, and then add it back again.
This will create the resource group and storage account where the state file will be stored, and then you can add the backend.tf file back again.
With this, the state file will be stored in the storage account and you won't have to worry about it anymore.

if this does not work, do the same process but running it locally, if it works the workflow should work too, as it will now know the state of the infrastructure.

Also, apart from the vm for the application, we create a vm for sonar, this is a code quality tool that will help you to see the quality of your code, it will run a scan on the code and show you the results in the sonar dashboard, you can access it using the ip of the vm.
