FROM microsoft/dotnet:2.1.301-sdk AS builder
WORKDIR /source

RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -
RUN apt-get install -y nodejs
RUN apt-get install -y npm
RUN npm install react-scripts@2.1.2 -g


COPY *.csproj .
RUN dotnet restore

COPY ./ ./

RUN dotnet publish "./react-app.csproj" --output "./dist" --configuration Release --no-restore

#FROM microsoft/dotnet:2.1.1-aspnetcore-runtime
FROM microsoft/dotnet:2.2-runtime-deps-stretch-slim-arm32v7
WORKDIR /app
COPY --from=builder /source/dist .
EXPOSE 80
ENTRYPOINT ["dotnet", "react-app.dll"]