# Terraform templates

Utilizing [Terraform's module](https://www.terraform.io/docs/modules/usage.html) feature to create a simple and reusable infrastructure (e.g. autoscaling frontend apps and backend servers deployed on one region but different zones at the back of a load balancer, and all within an isolated VPC).

# Use Case

Initially, the way I spawn my clients' infrastructure is by using this file layout.

```
client_1
  └ vpc
  └ services
      └ frontend-app
      └ backend-app      
client_2
  └ vpc
  └ services
      └ frontend-app
      └ backend-app
```

Whenever there's a new client coming in, I would just clone one directory then just modify the source code inside it. This method would eventually lead to problems like:
* inconsistencies because the entire source code needs to be edited
* non-uniformity to the other infrastructure because it doesn't depend on one true source tree
* more prone to human errors

# Solution

As a DevOps engineer, I've decided to take advantage of Terraform's module feature. I have separated the main source code that imports the module/s to be used, the output/ss it needs to be passed to the other modules, and the variable file that inputs variable to the module. So here's an improvement of the file layout that would address the problems presented above.

```
|-- modules
|   |-- network
|   |   |-- main.tf
|   |   |-- outputs.tf
|   |   `-- vars.tf
|   `-- services
|       |-- backend
|       |   |-- main.tf
|       |   `-- vars.tf
|       `-- frontend
|           |-- main.tf
|           |-- outputs.tf
|           `-- vars.tf
`-- sample_client
    |-- network
    |   |-- main.tf
    |   `-- sample_vars.tf
    `-- services
        |-- backend
        |   |-- main.tf
        |   `-- sample_vars.tf
        `-- frontend
            |-- main.tf
            `-- sample_vars.tf
```

In this way, I would still clone one client's directory but instead, just edit the `sample_vars.tf` file. In this way, it would be able to address the eventual problems we might experience.

# Extra tools used

Basically, the flow of creating this infrastructure is this way:

1) Create an isolated VPC
2) Create the autoscaling frontend servers
4) Create the autoscaling backend servers

The problem with this one is that this can't be created simultaneoulsy. Before you can proceed to step 2 or 3, step 1 needs to be created first.

Modules are very simple yet very tricky to use as well. A module is basically a directory. If you are in your root terraform directory, you're in root module. Once you create a directory inside that root directory, that's going to be a submodule and so on.

I experienced a great deal of problems with modules.. from exposing outputs from submodule to root module, cross module variable dependency, to creating read-only tfstate in s3.

So i used these tools as well:
* [Remote State](https://www.terraform.io/docs/providers/terraform/d/remote_state.html)
* [Data Sources](https://www.terraform.io/docs/configuration/data-sources.html)

I hope that these templates and modules I have created here could also help some newbies to Terraform.

# Future Work
* Include RDS module
* Integrate state file locking
* Creating a wrapper to do something like:
`create_client --region <region> --vpc <cidr> --frontend <options> --backend <options>`
