//
//  ViewController.swift
//  Chat Socket
//
//  Created by MAC on 8/14/17.
//  Copyright © 2017 example.com. All rights reserved.
//

import UIKit
import SocketIO

class ViewController: UIViewController {
    var socket = SocketIOClient(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress])
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initSocket()
    }

    @IBOutlet weak var textField: UITextField!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeText(_ sender: Any) {

    }

    @IBAction func sendMessage(_ sender: Any) {
        socket.on(clientEvent: .connect) { (data, ack) in
            if let cur = data[0] as? Double {
            self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                self.socket.emit(self.textField.text!, ["amount": cur + 2.50])
                }
            }
        }
    }
}

extension ViewController {
    func initSocket() {
        socket.on(clientEvent: .connect) {data, ack in
            self.socket.emit("chat message", "draven")
        }
        
        
        socket.on("currentAmount") {data, ack in
            if let cur = data[0] as? Double {
                self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                    self.socket.emit("update", ["amount": cur + 2.50])
                }
                
                ack.with("Got your currentAmount", "dude")
            }
        }
        socket.connect()
        
    }
}

