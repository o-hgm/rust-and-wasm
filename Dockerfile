FROM rust as build-wasm

RUN mkdir -p /pyramid
COPY ./pyramid /pyramid

WORKDIR /pyramid
RUN cargo install wasm-pack

RUN wasm-pack build --target web


FROM node as web-app

RUN mkdir -p /web /pyramid-wasm

COPY --from=build-wasm /pyramid/pkg /pyramid/pkg
COPY ./web /web

WORKDIR /web
RUN npm i

CMD ["npm", "run", "serve"]
EXPOSE 8080