#README#

## Security precautions ##
We ain't want no one to get caught, so you might want to change your hostname, ip adress,
hair color and move to Zimbabwe.



## Usage 

There are two types of usage, interactive and non-interactive


###Non-interactive###

For test use:
```
python mailer.py  <file with target emails> <file with email in html format>
```
###Interactive###
```
python mailer.py -i
```

##Help
```
python mailer.py --help
```


##TO DO
* add delay setting support


##Might help
How to change hostname and domain
Mac os:
add 
```
myhostname=newtesthostname
mydomain=newtestdomain
```
to the

/etc/postfix/main.cf
