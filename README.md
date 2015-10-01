## Projects

### Dependencies
Should be described in Gemfile

- [git-up](https://github.com/aanand/git-up)
 - updates all the branches in repo

### Rake

- proj:update_all &ndash; Updates all projects
- proj:gemfile &ndash; Generates new gemfile
  (e.g. rake proj:gemfile\\['rspec|sequel','/tmp/sok'\\])

### Troubleshooting

In case of git up is running under wrong Ruby environment, check [RVM info in git-up project](https://github.com/aanand/git-up/blob/master/RVM.md)
