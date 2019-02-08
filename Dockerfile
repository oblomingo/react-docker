FROM microsoft/dotnet:2.2-sdk AS builder
#FROM microsoft/dotnet:2.2-sdk-stretch-arm32v7 AS builder
WORKDIR /source

RUN curl -sL https://deb.nodesource.com/setup_10.x |  bash -
RUN apt-get install -y nodejs

COPY *.csproj .
RUN dotnet restore

COPY ./ ./

RUN dotnet publish "./react-app.csproj" --output "./dist" --configuration Release --no-restore

#FROM microsoft/dotnet:2.2-aspnetcore-runtime
FROM microsoft/dotnet:2.2-aspnetcore-runtime-stretch-slim-arm32v7 as runtime
WORKDIR /app
COPY --from=builder /source/dist .
EXPOSE 80
ENTRYPOINT ["dotnet", "react-app.dll"]