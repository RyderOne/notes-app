export default {
    MAX_ATTACHMENT_SIZE: 5000000,
    s3: {
        REGION: "eu-west-1",
        BUCKET: "ryderone-notes-app-uploads"
    },
    apiGateway: {
        REGION: "eu-west-1",
        URL: "https://qg4dhpg8bk.execute-api.eu-west-1.amazonaws.com/prod"
    },
    cognito: {
        REGION: "eu-west-1",
        USER_POOL_ID: "eu-west-1_eOoWPg001",
        APP_CLIENT_ID: "5if9k17a0ej1393h591h5gf5ls",
        IDENTITY_POOL_ID: "eu-west-1:ca01a5df-0013-46f9-9ddb-4989b80a8af9"
    }
};