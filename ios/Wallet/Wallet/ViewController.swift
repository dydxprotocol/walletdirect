//
//  ViewController.swift
//  Wallet
//
//  Created by Qiang Huang on 11/11/21.
//

import UIKit
import WalletDirect

class ViewController: UIViewController {
    @IBOutlet var textView: UITextView?
    @IBOutlet var approveButton: UIButton?
    @IBOutlet var rejectButton: UIButton?

    @IBOutlet var appNameLabel: UILabel?
    @IBOutlet var developerLabel: UILabel?

    private var processor = WalletDirectProcessor()

    internal var lastRequest: WalletDirectRequest? {
        didSet {
            didSetLastRequest()
        }
    }

    internal var appRegistry: Registry? {
        didSet {
            didSetAppRegistry()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        didSetLastRequest()
        didSetAppRegistry()
        WalletDirectManager.shared = DApps(receiving: { [weak self] request, registry in
            self?.lastRequest = request
            self?.appRegistry = registry
        })
    }

    func didSetLastRequest() {
        if let lastRequest = lastRequest {
            approveButton?.isEnabled = true
            rejectButton?.isEnabled = true
            textView?.text = lastRequest.payload().description
        } else {
            approveButton?.isEnabled = false
            rejectButton?.isEnabled = false
            textView?.text = nil
        }
    }

    func didSetAppRegistry() {
        if let appRegistry = appRegistry {
            appNameLabel?.text = appRegistry.name
            developerLabel?.text = appRegistry.developer
        } else {
            appNameLabel?.text = nil
            developerLabel?.text = nil
        }
    }

    @IBAction func approve(_ sender: Any?) {
        if let lastRequest = lastRequest {
            let result = processor.process(request: lastRequest, walletProcessing: { thisProtocol, chainId, account in
                let response = WalletDirectProtocolResponse(data: nil)
                if thisProtocol == "ethereum" {
                    response.chainId = chainId ?? "3" // Ropsten
                    response.account = account ?? "0x00000000001111111111222222222233"
                    response.successful = true
                } else {
                    response.successful = false
                }
                return response
            }, methodProcessing: { thisProtocol, chainId, account, method in
                let response = WalletDirectResponse(data: nil)
                if thisProtocol == "ethereum" {
                    if let eth_signTypedData = method.jsonRpc?["eth_signTypedData"] as? [String: Any] {
                        response.successful = true
                        response.jsonRpc = ["Data": "Dummy"]
                    } else {
                        response.successful = false
                    }
                } else {
                    response.successful = false
                }
                return response
            })
            (WalletDirectManager.shared as? DApps)?.respond(result: result, completion: { [weak self] _ in

            })
        }
    }

    @IBAction func reject(_ sender: Any?) {
        let result = WalletDirectResult(data: [:])
        result.id = lastRequest?.id
        result.successful = false
        (WalletDirectManager.shared as? DApps)?.respond(result: result, completion: { [weak self] _ in

        })
    }
}
