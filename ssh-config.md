in `~/.ssh/config` configure the following:
```yaml
# Work GitHub SSH
Host work
  HostName github.com
  User git
  IdentityFile "~/.ssh/github-work.pub"
  IdentitiesOnly yes

# Personal GitHub SSH
Host me
  HostName github.com
  User git
  IdentityFile "~/.ssh/github.pub"
  IdentitiesOnly yes
```

to test the config is ok, run `ssh -T git@work` and `ssh -T git@me`

and then, when configuring the git remote, we can use them like:
`git clone git@work:username/repository.git`
