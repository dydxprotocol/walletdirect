//
//  ViewController.swift
//  DApp
//
//  Created by Qiang Huang on 11/11/21.
//

import UIKit
import WalletDirect

class ViewController: UIViewController {
    @IBOutlet var requestTextView: UITextView?
    @IBOutlet var resultTextView: UITextView?

    @IBOutlet var sendButton: UIButton?
    
    internal var lastRequest: WalletDirectRequest? {
        didSet {
            didSetLastRequest()
        }
    }

    internal var lastResult: WalletDirectResult? {
        didSet {
            didSetLastResult()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        didSetLastRequest()
        didSetLastResult()
        WalletDirectManager.shared = Wallets(dAppId: "151732fa9c0b84ef92654cd4388409c4e2ebc81a6a76c05d0c62f7979271e44b", receiving: { [weak self] result, request in
            self?.lastRequest = request
            self?.lastResult = result
        })
    }

    func didSetLastRequest() {
        if let lastRequest = lastRequest {
            requestTextView?.text = lastRequest.payload().description
        } else {
            requestTextView?.text = nil
        }
    }

    func didSetLastResult() {
        if let lastResult = lastResult {
            resultTextView?.text = lastResult.payload().description
        } else {
            resultTextView?.text = nil
        }
    }

    @IBAction func getWalletAddress(_ sender: Any?) {
        if let wallets = WalletDirectManager.shared as? Wallets, let installed = wallets.installed().first {
            wallets.getAccounts(protocols: ["ethereum": "3"], registry: installed) { [weak self] _ in
            }
        } else {
            message("No wallet is installed")
        }
    }

    @IBAction func sendSigningRequests(_ sender: Any?) {
//        if let wallets = WalletDirectManager.shared as? Wallets, let installed = wallets.installed().first {
//            let dummyMethod = ["method": "Sign", "data": "Dummy Data"]
//            wallets.send(chainId: 3, account: "0x1234", rpcMethods: [dummyMethod], registry: installed) { _ in
//            }
//        } else {
//            message("No wallet is installed")
//        }
    }

    private func message(_ message: String) {
    }
}
