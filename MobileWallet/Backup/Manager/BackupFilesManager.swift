//  BackupFilesManager.swift
    
/*
    Package MobileWallet
    Created by Adrian Truszczynski on 15/04/2022
    Using Swift 5.0
    Running on macOS 12.3

    Copyright 2019 The Tari Project

    Redistribution and use in source and binary forms, with or
    without modification, are permitted provided that the
    following conditions are met:

    1. Redistributions of source code must retain the above copyright notice,
    this list of conditions and the following disclaimer.

    2. Redistributions in binary form must reproduce the above
    copyright notice, this list of conditions and the following disclaimer in the
    documentation and/or other materials provided with the distribution.

    3. Neither the name of the copyright holder nor the names of
    its contributors may be used to endorse or promote products
    derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
    CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
    INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
    OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
    CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
    NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
    LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
    HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
    CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
    OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import Zip

enum BackupFilesManager {
    
    static var encryptedFileName: String { "Tari-Aurora-Backup" + "-" + NetworkManager.shared.selectedNetwork.name }
    static var unencryptedFileName: String { encryptedFileName + ".zip" }
    
    private static let internalWorkingDirectoryName = "Internal"
    
    private static let workingDirectory = FileManager.default.temporaryDirectory.appendingPathComponent("Backups")
    private static var fileDirectory: URL { Tari.shared.connectedDatabaseDirectory }
    
    static func prepareBackup(workingDirectoryName: String, password: String?) async throws -> URL {
        let workingDirectory = try prepareWorkingDirectory(name: workingDirectoryName)
        try Tari.shared.encryption.remove()
        let fileURL = try copyDatabase(workingDirectory: workingDirectory)
        try Tari.shared.encryption.apply()
        let zipFileURL = workingDirectory.appendingPathComponent(unencryptedFileName)
        try await zipDatabase(inputURL: fileURL, outputURL: zipFileURL)
        
        guard let password else { return zipFileURL }
        
        let encryptedFileURL = workingDirectory.appendingPathComponent(encryptedFileName)
        try encryptFile(inputURL: zipFileURL, outputURL: encryptedFileURL, password: password)
        
        return encryptedFileURL
    }
    
    static func store(backup: URL, password: String?) async throws {
        
        var zipURL = backup
        
        if let password {
            zipURL = try prepareWorkingDirectory(name: internalWorkingDirectoryName).appendingPathComponent(unencryptedFileName)
            try decryptFile(inputURL: backup, outputURL: zipURL, password: password)
        }
        
        try await unzipDatabase(inputURL: zipURL, outputURL: fileDirectory)
    }
    
    private static func workingDirectoryURL(name: String) -> URL {
        workingDirectory.appendingPathComponent(name)
    }
    
    static func prepareWorkingDirectory(name: String) throws -> URL {
        
        try removeWorkingDirectory(workingDirectoryName: name)
        let directory = workingDirectoryURL(name: name)
        
        if !FileManager.default.fileExists(atPath: directory.path) {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true,attributes: nil)
        }
        
        return directory
    }
    
    static func removeWorkingDirectory(workingDirectoryName: String) throws {
        let workingDirectory = workingDirectoryURL(name: workingDirectoryName)
        guard FileManager.default.fileExists(atPath: workingDirectory.path) else { return }
        try FileManager.default.removeItem(atPath: workingDirectory.path)
    }
    
    private static func copyDatabase(workingDirectory: URL) throws -> URL {
        
        let filename = Tari.shared.databaseURL.lastPathComponent
        let workingFileURL = workingDirectory.appendingPathComponent(filename)
        
        if FileManager.default.fileExists(atPath: workingFileURL.path) {
            try FileManager.default.removeItem(at: workingFileURL)
        }
        
        try FileManager.default.copyItem(at: Tari.shared.databaseURL, to: workingFileURL)
        return workingFileURL
    }
    
    private static func zipDatabase(inputURL: URL, outputURL: URL) async throws {
        try await withCheckedThrowingContinuation { continuation in
            do {
                try Zip.zipFiles(paths: [inputURL], zipFilePath: outputURL, password: nil) { progress in
                    guard progress >= 1.0 else { return }
                    continuation.resume(with: .success(()))
                }
            } catch {
                continuation.resume(with: .failure(error))
            }
        }
    }
    
    private static func unzipDatabase(inputURL: URL, outputURL: URL) async throws {
        
        try await withCheckedThrowingContinuation { continuation in
            do {
                try Zip.unzipFile(inputURL, destination: outputURL, overwrite: true, password: nil, progress: { progress in
                    guard progress >= 1.0 else { return }
                    continuation.resume(with: .success(()))
                })
            } catch {
                continuation.resume(with: .failure(error))
            }
        }
    }
    
    private static func encryptFile(inputURL: URL, outputURL: URL, password: String) throws {
        let encryption = try AESEncryption(keyString: password)
        let data = try Data(contentsOf: inputURL)
        let encryptedData = try encryption.encrypt(data)
        try encryptedData.write(to: outputURL)
    }
    
    private static func decryptFile(inputURL: URL, outputURL: URL, password: String) throws {
        let encryption = try AESEncryption(keyString: password)
        let data = try Data(contentsOf: inputURL)
        let decryptedData = try encryption.decrypt(data)
        try decryptedData.write(to: outputURL)
    }
}
