# Current Proposal

Current Proposal

Current proposal is at https://docs.google.com/document/d/1Z93XY9tkO2hbnruD9Q1LVnK0BjELgqWUfWu21vKMynU/edit?usp=sharing


# Background

Wallet Connect and Walletlink are designed for communication between desktop dApp and mobile wallet, which resides on two different devices. The communication is done through a bridge server. Both dApp and wallet connect to the server with websocket. 

Although it is possible to connect dApp and wallet on the same mobile device with the same protocols, there is an inherent technical limitation. When mobile apps (both dApp and wallet) are backgrounded, they are paused by the OS after a short period of time, thus losing the websocket connection to the server.

Wallet Connect 2.0 and Walletlink are designed to recover the connection. Walletlink has no adoption, other than Coinbase Wallet. Wallet Connect 2.0 is still in the early stage with mobile SDK in beta, and only useful if both dApp and wallet support it.

Even in the ideal situation, having a constant websocket connection to an external server is an extra point of failure. The connection may be lost as the user is on the move. The server may be overloaded and cannot process the traffic.

When both dApp and wallet are located on the same device, there is no need to route the traffic through an external server. This proposal is to facilitate the communication between dApp and wallet through deeplinks.

# Usage

This protocol is designed to perform multiple methods in one pass. For example, the dApp may request the wallet to sign multiple messages, or to sign multiple messages and send one transaction. The wallet should inform the user about the source of the connection, and can either prompt the user for confirmation for each method, or a single confirmation for all methods.

The response only returns success if all actions are successful. When successful, the response should contain the results of each action.

# Public registry

Both dApp and wallet should have a custom link for the connection and use params to pass data. The dApp should be a native app released through Apple App Store or Google Play.

The communication is always initiated by dApp. For the dApp to be aware of the installed wallet apps supporting this protocol, there needs to be a public registry with wallet info. For security reasons, the wallet app uses dApp registry for validation callbacks.

**Best practices: Although the registry is available as a public github repo, the Wallet app can take a snapshot of the registry as build time and include it as part of the app, to avoid man-in-the-middle attack on the repo.**

Note: If the protocol support is added to an existing wallet, the wallet should add a new deep link scheme, so the dApp can differentiate different builds of the wallet and only use this protocol if the wallet supports it.

**dApp registry**
{
   "(dapp_uuid)":{
      "name":"(dApp name)",
      "platforms":{
         "ios":{
            "bundleId":"(Bundle ID of the app, with format of TEAMID.com.company.app"
         },
         "android":{
            "packageId":"(Package ID of the app, with format of com.company.app)",
            "hash":[
               "(The registry should be updated with the hash of each release"
            ]
         }
      },
      "deeplink":"(deep link scheme and path to return response)",
      "metadata":{
         "shortName":"(Short name for dApp to display)",
         "imageUrl":"(image URL for the wallet logo)",
         "developer":"(dApp developer name)",
         "developerUrl":"(dApp developer website URL)"
      }
   }
}




**Wallet registry**
{
   "(wallet_uuid)":{
      "name":"(Wallet name)",
      "deeplink":"(deep link scheme and path to send request",
      "platforms":{
         "ios":{
            "supported":[
               "(list of dApp ID)"
            ]
         },
         "android":{
            "supported":[
               "(list of dApp ID)"
            ]
         }
      },
      "metadata":{
         "shortName":"(Short name for dApp to display)",
         "imageUrl":"(image URL for the wallet logo)",
         "developer":"(dApp developer name)",
         "developerUrl":"(dApp developer website URL)"
      }
   }
}



# Params Format

Similar to webpage URL, deeplinks can process data in URL params.

To simplify development, the protocol can use a single param, which is a base64 encoded string of a JSON body.

(wallet_deep_link)?data=(base64_encoded_json_string)

**Payload Format from dApp to wallet**

The data param is a base64 encoded JSON body, containing the request for the connection, and a list of actions for the wallet to perform.

{
   "dapp_uuid":"(dApp UUID in registry)",
   "chainId":"(optional)",
   "account":"(optional, desired wallet account ID)",
   "methods":[
   ]
}

**dapp_uuid** identifies the dApp’s UUID in the **dApp registry**. Wallet should use the registry to fetch dApp’s information and display dApp’s name and image to the user. If dapp_uuid does not exists in the registry, Wallet should respond with NOOP

From the dApp registry
        name is the full name of the dApp
        metaData.shortName can be use for display to the user
        metaData.imageUrl is the image URL of the app icon
        metaData.developer is the name of the dApp developer
        metaData.developerUrl is the website URL of the developer

**chainId** identifies the preferred chain ID of the network, such as 1 for MainNet or 3 for Ropsten. If chainId is different from the currently selected network in the Wallet App, Wallet App can either reject the connection, or automatically switch to the designated network. If chainId is null, Wallet App uses the currently selected network.

**account** identifies the requested account ID (ethereum address) of the wallet.  If accountId is different from the currently selected account, Wallet App can either reject the connection, or automatically switch to the designated account. If the accountId does not belong to the wallet, Wallet App will reject the connection. If accountId is null, Wallet App should connect to the currently selected account.

Technical Note: Native dApps must include the supported deep link scheme at build time.

**methods** is a list of method object

method:
{
   "id":"(unique ID, generated by dApp)",
   "optional":true,
   "JSON-RPC":"(JSON-RPC method)"
}

**id** is generated by the dApp to identify the action, to make it easier to process the response

**optional** is an optional field indicating whether this is an optional method. It defaults to false, meaning the method is required. If it is false, the whole request stops if the user rejects this method. If it is true, the Wallet App should continue to process the next method even if the user rejects this method.

**JSON-RPC** is standard JSON-RPC method payload. For example, on Ethereum, it supporting eth_personalSign, eth_sign, eth_signTypedData, eth_sendTransaction, eth_sendRawTransaction, eth_signTransaction

UX Notes: The Wallet App should display [d][e]the dApp name, icon, developer name, and developer URL with the method requests. If the user taps on the developer URL, the Wallet App should launch the developer’s website in a browser.

UX Notes: When multiple methods are included, the Wallet App can choose to perform each method sequentially, or display them in a list and only request one confirmation.

If Wallet App performs each method sequentially and the user rejects a non-optional method, the rest of the methods are cancelled.

**Payload Format from wallet to dApp**

When the user performs all methods without rejecting a non-optional method, the Wallet App should use the dApp registry’s callback to launch a universal link or deep link, to pass the response back to the dApp.

(backlink)?data=(base64_encoded_json_string)

The result is the a based64 encoded JSON body, which decodes to
{
    "successful":true,
    "chainId":"(connected chainId, if successful)",
    "account":"(connected wallet account, if successful)",
    "responses":[
        (an array of result object)
    ]
}

**successful** is a boolean indicating all methods are performed successfully.

**chainId** identifies the connected chain ID of the network, if successful

**account** identifies the connected account ID (ethereum address) of the wallet, if successful

**responses** contains a list of response object

response:
{
    "id":"(unique ID, generated by dApp)",
    "successful":true,
    "JSON-RPC":"(JSON-RPC response)"
}

**id** is the action id generated by dApp.

**successful** is a boolean indicating whether this method was successful. 


**JSON-RPC** is the standard JSON-RPC method response for the matching method.

The number of items in responses must match the number of items in methods from dApp.

If the user reject a non-optional method, the result body will contain:
{
   "successful":false,
   "error":{
      "id":"(id of the method)",
      "message":"(error message from on chain)"
   }
}

**error** identifies the failed non-optional method, and contains a human readable message.

**id** is the method ID in dApp’s request.

**message** is a human readable message identifying the cause of the failure. For example, it can be “rejected by user”, or “not enough gas”

# Build Notes for dApps

At build time, dApp should retrieve the current Wallet registry, and add the deep link scheme into the build settings.

Android dApp developer should update the dApp registry with the signature hash of each build

# Build Notes for Wallets

At build time, Wallet should retrieve the current dApp registry, and add the deep link scheme into the build settings.

Wallet should include a copy of the dApp registry in the app, and update the Wallet registry with the dApp ID’s in the  “supported” field.

# Security Notes

With version 1 of this spec, the deep link direct communication is only allowed between native dApp and Wallet. Wallet should verify against impersonation of the dApp.

This is the recommended practice
