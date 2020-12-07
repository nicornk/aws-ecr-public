const https = require('https');
const assert = require('assert').strict;

const { METHOD, BASIC_USER, BASIC_PASSWORD } = process.env;

const UNAUTHORIZED = new Error('Unauthorized');

function basicAuth(user, password) {
    assert(user === BASIC_USER && password === BASIC_PASSWORD, UNAUTHORIZED);
}

exports.handler = async ({ authorizationToken }) => {
    const [type, encoded] = authorizationToken.split(/\s+/, 2);
    const [user, password] = Buffer.from(encoded, 'base64').toString().split(':', 2);

    if (METHOD === 'BASIC') {
        await basicAuth(user, password);
    } else throw UNAUTHORIZED;

    return {
        policyDocument: {
            Version: '2012-10-17',
            Statement: [{
                Effect: 'Allow',
                Resource: '*',
                Action: 'execute-api:Invoke',
            }]
        },
    };
};
