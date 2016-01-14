#!/bin/sh

modulePath="node_modules"

if [ ! -d "$modulePath" ]; then
    echo "Not found node_modules! && install"
    npm install --registry=http://registry.npm.corp.qunar.com/
fi

hexo clean
hexo g
