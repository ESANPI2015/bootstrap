# Bootstrapping

```bash
# install git if not present
which git 2&>1 > /dev/null || sudo apt-get install git
wget -P /tmp/ https://raw.githubusercontent.com/ESANPI2015/bootstrap/master/bootstrap.sh
export DEV_ROOT=$HOME/dev
sh /tmp/bootstrap.sh $DEV_ROOT
```
NOTE: Adjust ``DEV_ROOT`` to your needs
