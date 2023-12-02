# Linux & Shell Scripting Overview

Concepts:
* Aliases
* Configuring .bashrc with vim
* Sourcing
* Exporting variables / scope
* UNIX Streams
* Shell logic and control flow

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

* `tr word1 word2 < file.txt`: replace word1 with word2 in file.txt

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

## Shell Logic & Control Flow
If-Else syntax: 
```shell
echo "What food do you choose? "
read FOOD

if [ "$FOOD" = "Apple" ]; then
	echo "Eat Yoghurt with your Apple"
elif [ "$FOOD" = "Milk" ]; then
	echo "Eat Cereal with your Milk"
else
	echo "Eat your ${FOOD} by itself"
fi
```

## Arrays & loops
Syntax to declare an array:
```shell
declare -a array=("apple" "pear" "cherry")
```
_Note: When you use -a, you indicate you're creating an array. Failing to provide the "-a" option may lead the shell to misinterpret the variable type_


### For-Loop
Syntax to loop through an array:
```shell
for i in "${array[@]}"
do
    echo "This ${i} is delicious"
done

```

### While-Loop
```shell
COUNT=1
while [ $COUNT -le $LOOPS]
do
    echo "Loop# $COUNT "
    ((COUNT++))
done
```
_Note: The spaces aroung "[" and "]" are mandatory. Without them, you'll get a syntax error._


## Logic operators (&&, ||) in Bash

With `&&`, command-2 will run iff command-1 executes successfully.
```shell
command-1 && command-2
```

With `||`, command-2 will run iff the first one fails.
```shell
command-1 || command-1
```

For example
```shell
echo "Text 1" && echo "Text 2"  # Output: Text 2
false && echo "Text 2"          # Output: -
echo "Text 1" || echo "Text 2"  # Output: Text 1
false || echo "Text 2"          # Output: Text 2
```

## Bash Shell techniques for Data
* Truncate
* Filter
* Search

### Truncating data in Bash
`head` command takes by defatuls the top 10 rows from the file: 
```shell
head file.txt
```
To change the default number, use `-n`
```shell
head -n 5 file.txt
```
Similarly, `tail` takes the bottom 10 rows:
```shell
tail file.txt
tail -n 5 file.txt
```

To shuffle the data without opening the entire file:
```shell
shuf file.txt
```

You can combine this with `head` to get only a specific number of rows:
```shell
shuf file.txt | head -n 5
```

### Filtering files with Bash
`grep` command allows searching for patterns within a file. For example, the following line will print all lines where "apple" is present:
```shell
grep apple file.txt
```

To show the count instead of each instance, use `-c`:
```shell
grep -c apple file.txt
```

To search for multiple words and sum their occurances, use `-e`:
```shell
grep -c -e apple -e pear file.txt
```

Alternatively, to look for lines that DO NOT contain a word (pattern), use `-v`:
```shell
grep -v apple file.txt
```

### Custom patterns
The command `find` allows going over files and searching for specific filenames. For example, the line below looks in the current directory, denoted by the dot (.), and looks for any files whose name ends with ".sh". In other words, it finds all bash scripts within the current directory:
```shell
find . -name "*.sh"
```
A more complex command, like the one below, allows searching only for executable files (`-perm /+x`), as long as (`!`) those files aren't invisible (`-name '.*'`). It also ignores folders (`-type f`):
```shell
find . -perm /+x ! -name '.*' -type f
```
To search the entire filesystem, you need "admin rights", which you get by using `sudo`: 
```shell
sudo find / -name .zshrc
```
_Note: the `find` command works in real time, unlike `locate`, which uses a database that needs to be updated regularly to include new files created after the last update.
To use the `locate` command, first install it:
```shell
# For debian systems
sudo apt-get install mlocate

# For ubuntu systems
sudo yum install mlocate
```

Then update the database and start searching for files:
```shell
sudo updatedb
locate .zshrc   # looks for all .zshrc files in the filesystem up to the latest database update
locate -i .ZSHRC    # matches all .zshrc files regardless of the case
locate -c .zshrc    # counts how many .zshrc files were found
```

## Bash script basics
When you include the shebang at the top of the file in the following way, you can directly execute .sh files without explicitly typing the `bash` command beforehand. In order for this to work, make the .sh file executable by using `chod +x filename.sh` in the terminal. Shebang example:
```shell
#!/usr/bin/env bash
```

* `set -e`: set strict mode. Causes shell to exit when a command fails. Makes your code more robust against potential errors.
* `set -v`: enables printing of shell input lines as they are read. Nice for debugging.
* `set -x`: enables printing of command traces before executing the command. Tells you what it's about to do, and then does it.

### Functions syntax
```shell
mimic() {
    echo "First parameter: $1"
    echo "Second parameter: $2"
    echo "Third parameter: $3"
}

add() {
    num1=$1
    num2=$2
    result=$((num1 + num2))
    echo $result
}

# Will not echo the result, because it is captured into a variable
output=$(add 4 5)

add $output 4
```

### Parsing input from terminal
`$#` is a special variable that holds the number of command-line arguments. In the example below, the while loop checks whether the number of args is greater than one (`-gt`). If so, it assigns the current arg to a variable `key`.
```shell
while [[ $# -gt 1 ]]
do
key="$1"
```

### Example bash script
```shell
i=1;    #initialize count
j=$#;   #get script input size

while [[ $# -ge 1 ]]
do
    rstring=$(echo $1 | rev);
    echo "Reversing string $i: $1: $rstring";
    i=$((i + 1));   #increment the count
    shift 1;        #process the next argument
done

# run
./palindromes.sh | xargs ./reverse.sh
```

In the code above, `xargs` takes each line of the output from `palindromes.sh` and uses it as input for `reverse.sh`

## Makerfile vs. Dockerfile
Makerfile:
* Automates: it's been used for decades.
* Recipe: a series of recipes.
* Bash-like: it mostly looks like bash, with some subtle differences.

Dockerfile:
* Automates:
* Containers:
* Format

## Searching the Linux filesystem
* Visual
* Live: `find`
* Metadata: with `locate`. You need to run a command `updatedb`, which most people do using a cron job. In OS X, they have `mdefined` instead of `updatedb`.


Next steps:
[(Book; PDF) Advanced Bash Scripting Guide](https://tldp.org/LDP/abs/abs-guide.pdf)
[(Website) Makefile Tutorial by Example](https://makefiletutorial.com/)