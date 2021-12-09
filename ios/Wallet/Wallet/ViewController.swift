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
            let result = processor.process(request: lastRequest, walletProcessing: { chainId, account in
                let response = WalletDirectProtocolResponse(data: nil)
                response.chainId = "3"  // Ropsten
                response.account = "0x00000000001111111111222222222233"
                return response
            }, methodProcessing: { request in
                let response = WalletDirectResponse(data: nil)
                response.successful = true
                response.jsonRpc = ["Data": "Dummy"]
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
