FROM node:22-alpine

ARG GOOGLE_CALENDAR_MCP_VERSION=2.6.1

RUN apk add --no-cache curl \
  && npm install -g "@cocal/google-calendar-mcp@${GOOGLE_CALENDAR_MCP_VERSION}" \
  && mkdir -p /app/secrets /home/node/.config/google-calendar-mcp \
  && chown -R node:node /app /home/node

USER node
WORKDIR /home/node

ENTRYPOINT ["google-calendar-mcp"]
CMD ["start", "--transport", "http", "--host", "0.0.0.0", "--port", "3000"]
