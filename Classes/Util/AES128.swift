//
//  AES128.swift
//  GNAppKit
//
//  Created by Shanhu Ma on 2019/1/8.
//  Copyright © 2019年 Shanhu Ma. All rights reserved.
//

import Foundation
import CommonCrypto

public enum GNEncryptError: Error {
    case badKeyLength
    case badInputVectorLength
    case cryptoFailed(status: CCCryptorStatus, operation: CCOperation)
}

extension GNEncryptError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cryptoFailed(let status, let operation):
            if operation == CCOperation(kCCDecrypt) {
                return "[解密失败]\n状态码：\(status)"
            } else {
                return "[加密失败]\n状态码：\(status)"
            }
        case .badKeyLength:
            return "[初始化加密器失败]\n原因：密钥长度非法"
        case .badInputVectorLength:
            return "[初始化加密器失败]\n原因：向量长度非法"
        }
    }
}

public struct AES128 {
    
    /// 密钥
    private var key: Data
    
    /// 向量
    private var inputVector: Data
    
    /// 填充方式
    private var paddingMode: Int = kCCOptionPKCS7Padding // 效果同安卓 AES/CBC/PKCS5Padding
    
    public init(key: Data, inputVector: Data) throws {
        guard key.count == kCCKeySizeAES128 else {
            throw GNEncryptError.badKeyLength
        }
        guard inputVector.count == kCCBlockSizeAES128 else {
            throw GNEncryptError.badInputVectorLength
        }
        self.key = key
        self.inputVector = inputVector
    }
    
    /// 加密
    ///
    /// - Parameter originData: 要加密的 data
    /// - Returns: 加密结果 Data
    /// - Throws: cryptoFailed(status)
    public func encrypt(_ originData: Data) throws -> Data {
        return try crypt(input: originData, operation: CCOperation(kCCEncrypt))
    }
    
    /// 解密
    ///
    /// - Parameter encrypted: 要解密的 data
    /// - Returns: 解密结果 Data
    /// - Throws: cryptoFailed(status)、badBase64Data
    public func decrypt(_ encrypted: Data) throws -> Data {
        return try crypt(input: encrypted, operation: CCOperation(kCCDecrypt))
    }
    
    private func crypt(input: Data, operation: CCOperation) throws -> Data {
        var outLength = 0
        var outBytes = [UInt8](repeating: 0, count: input.count + kCCBlockSizeAES128)
        var status: CCCryptorStatus = CCCryptorStatus(kCCSuccess)
        input.withUnsafeBytes { (encryptedBytes: UnsafePointer<UInt8>!) -> () in
            inputVector.withUnsafeBytes { (ivBytes: UnsafePointer<UInt8>!) in
                key.withUnsafeBytes { (keyBytes: UnsafePointer<UInt8>!) -> () in
                    status = CCCrypt(operation,
                                     CCAlgorithm(kCCAlgorithmAES128),            // algorithm
                        CCOptions(paddingMode),           // options
                        keyBytes,                                   // key
                        key.count,                                  // keylength
                        ivBytes,                                    // iv
                        encryptedBytes,                             // dataIn
                        input.count,                                // dataInLength
                        &outBytes,                                  // dataOut
                        outBytes.count,                             // dataOutAvailable
                        &outLength)                                 // dataOutMoved
                }
            }
        }
        guard status == kCCSuccess else {
            throw GNEncryptError.cryptoFailed(status: status, operation: operation)
        }
        return Data(bytes: UnsafePointer<UInt8>(outBytes), count: outLength)
    }
}
