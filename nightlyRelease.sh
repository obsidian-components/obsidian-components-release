#!/bin/bash

# 1. 读取 manifest.json 文件，获取 version 字段的值
version=$(awk -F'"' '/"version":/ {print $4}' manifest.json)

# 2. 取第一部分和第二部分
# 使用 awk 提取前两部分，确保正确处理 2.10.x 这样的版本号
major_minor=$(echo $version | awk -F'.' '{print $1 "." $2}')

# 3. 获取当前日期，生成 yyMMdd 格式
current_date=$(date +%y%m%d)

# 4. 结合第二步获取到的内容拼接，得到新的 tag 名
new_version="${major_minor}.${current_date}"

# 更新 manifest.json 中的 version 字段
sed -i "" -E "s/\"version\": \".*\..*\..*\"/\"version\": \"$new_version\"/" manifest-BETA.json


# 5. 执行 git
git add .
git commit -m "Release $new_version"
git push
git tag $new_version
git push --tags

echo "New tag $new_version created and pushed."