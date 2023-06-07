docker run --rm \
             -d -p 9080:8080 \
             -v "${PWD}/searxng:/etc/searxng" \
             -e "BASE_URL=http://search.huazifan.eu.org/" \
             -e "INSTANCE_NAME=HuaSearch" \
             searxng/searxng
