# Linux & Shell Scripting Overview

Concepts:
* Aliases
* Configuring .bashrc with vim
* Sourcing
* Exporting variables / scope
* UNIX Streams

## SSH (Secure Shell) Toolbox
### Connecting to a server
If you have a laptop that wants to talk to a cloud server, you use an SSH to connect to it, and then treat it as your local machine by executing bash commands from the terminal. Friendly to developers.

### Tunneling ports
If you work with sensitive data, e.g., military or healthcare, you can tunnel and forward the server's port to your port. Say a Flask server is running on server, then you can make it run in your local machine.

Example:

```shell
.ssh ssh -N -L 8080:127.0.0.1:8080 ec2-user@54.89.238.83
```

Explanations:
.ssh: This is referring to the directory where your SSH configuration and key files are stored. Typically, this is a hidden directory in a user's home directory.

ssh: This is the command to start a new SSH session.

-N: This option tells SSH that no command will be sent once the tunnel is up. It's useful for just forwarding ports.

-L 8080:127.0.0.1:8080: This is the syntax for port forwarding. It's saying “forward my local port 8080 to port 8080 on the remote machine at 127.0.0.1”.

ec2-user@54.89.238.83: This specifies the user and the IP address of the remote machine you're connecting to. In this case, the user is ec2-user and the IP address is 54.89.238.83.

### Checkout from GitHub
When you want to clone a repo, you can do it without a password using SSH keys.


## Commands
# Commands
* `>` directs the output of a command to a file
* `|` (pipe operator) directs the output of a command to another command

* `rsync`: The file synchronization process that commonly takes place using SSH is `rsync`. The `rsync` command is used to synchronize files and directories from one location to another while minimizing data transfer using delta encoding when appropriate. An important feature of `rsync` is that it works over SSH, providing security for the synchronized data.

Access links
```shell
curl 127.0.0.1:8080
```

## Working with CSV files 
```shell
head -n 1 nba_2017.csv > nba_2017_shuffled.csv
tail -n +2 nba_2017.csv | shuf >> nba_2017_shuffled.csv
```

Explanation part by part:
1. Appends the header (column names) as a first line into `nba_2017_shuffled.csv`
```shell
head -n 1 nba_2017.csv > nba_2017_shuffled.csv
```
2. Takes all rows starting from the second one (ignoring the column names)
```shell
tail -n +2 nba_2017.csv
```
3. appends (>>) those lines from step 2 into the file with the name columns from step 1
```shell
| shuf >> nba_2017_shuffled.csv
```


## .bashrc files
"Sourcing" a file means executing the commands in that file in the current shell, rather than in a subshell. This allows any variables or functions defined in that file to be used in the current shell.


## UNIX Streams

### Standard In
You can prompt the user to input text into the terminal using the following line:
```bash
read -p 'Input: ' INPUT
```
_The input is stored into the variable INPUT. Print it by running the `echo $INPUT` command_

Question: What do the backticks do in a bash file?

### Writing shell errors into a file
The following command checks if there is a directory named 'FAKEDIR' inside the root directory. When it doesn't find it, the error is written into the `error.txt` file, rather than being printed into the console. 
```shell
ls -l /FAKEDIR 2 > error.txt
```
_Note: Digit '2' is necessary for the command to work_

In case you don't want error messages polluting your environment, you pipe them into something known like /dev/null, and they will be thrown away (not stored anywhere, not printed to the shell):
```bash
ls -l /FAKEDIR 2 > /dev/null
```
