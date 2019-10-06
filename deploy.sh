#!/bin/bash
zip -r ./bin/build.zip ./bin/web/
butler push ./bin/build.zip alexferbrache/ludum-dare-45:web
