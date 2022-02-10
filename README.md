# Background
When both dApp and wallet are located on the same device, there is no need to route the traffic through an external server. This proposal is to facilitate the communication between dApp and wallet through deeplinks.

# Usage
This protocol is designed to perform multiple methods in one pass. For example, the dApp may request the wallet to sign multiple messages, or to sign multiple messages and send one transaction. The wallet should inform the user about the source of the connection, and can either prompt the user for confirmation for each method, or a single confirmation for all methods.

The response only returns success if all actions are successful. When successful, the response should contain the results of each action.
Benefits of this proposal
No need for socket connection to bridge server. Easier to code and test.
No need to handle app suspension when backgrounded (both both dApps and Wallets)
Wallet can use requested chain, chainId and account when requested, instead of returning error
Wallet brings dApp to foreground, regardless of the result. This is a better user experience

# Public Registry

Both dApp and wallet should have a custom link for the connection and use params to pass data. The dApp can be a web app, or a native app released through Apple App Store or Google Play.

The communication is always initiated by dApp. For the dApp to be aware of the installed wallet apps supporting this protocol, use the Wallet registry to retrieve all wallets supporting this protocol, and check which wallets are installed.

When Wallet receives a request with dApp ID, it should use the dApp registry to retrieve dApp information, and only allow transactions defined in the contracts field. It can prompt the user to sign or authorize each method sequentially, or have a single signing screen for all methods. Upon completion, it uses the deep link or universal link in the dApp registry to send the result back to dApp.

# Multi chain support

This proposal supports multi-chain wallets. dApp can specify the desired chain when sending connection, signing, or transaction request.

# Sample Code

This repo contains sample native iOS code, implementing this protocol. 

Use Xcode and open /ios/Samples. There are two app targets - Wallet and DApp.

To test, build and install both DApp and Wallet onto the same device or simulator
Run dApp, "Get Wallet Address" will send a connection request to the Wallet to get the address. "Send Signing Request" sends a sample signing request. In both cases, you can see the request payload in the Wallet app, and then the response payload in DApp, when you approve the requests in Wallet.

Note: Wallet doesn't really do the signing when receiving "Send Signing Request". It only returns a dummy signature.
