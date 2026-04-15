FROM alpine:3.18
RUN adduser -D -u 10001 aiuser && \
    rm -rf /var/cache/apk/*
USER aiuser
COPY --chown=aiuser:aiuser --chmod=750 ./tool_shim.sh /app/tool_shim.sh
ENTRYPOINT ["/app/tool_shim.sh"]