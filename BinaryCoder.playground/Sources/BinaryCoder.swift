//
//  BinaryCoder.swift
//  BinaryCoder
//
//  Copyright © 2019 R&F Consulting, Inc. All rights reserved.
//

import Foundation

// inspired by "A Binary Coder for Swift by Mike Ash", but way simpler
// https://www.mikeash.com/pyblog/friday-qa-2017-07-28-a-binary-coder-for-swift.html

public enum /* namespace */ BinaryCoder
{
	public enum DecodingError: Error
	{
		case prematureEndOfData
	}

	// support for Double
	
	@discardableResult // a consumer might not be interested in the number of bytes processed
	public static func encode(payload: Double, into data: inout Data) throws -> /* follow MemoryLayout<T> for byte-count */ Int
	{
		let byteCount = MemoryLayout<Double>.size

		// converts a 64-bit double from the host's native byte order to a platform-independent format
		var target = CFConvertDoubleHostToSwapped(payload)

		// invokes the given closure with a buffer pointer covering the raw bytes of the given argument
		withUnsafeBytes(of: &target) { data.append(contentsOf: $0) }

		return byteCount
	}

	@discardableResult
	public static func decode(_ data: Data, at offset: Int, into payload: inout Double) throws -> Int
	{
		let byteCount = MemoryLayout<Double>.size

		if offset + byteCount > data.count
		{
			throw DecodingError.prematureEndOfData
		}

		// a 64-bit float value in a platform-independent byte order
		var swapped = CFSwappedFloat64()

		// access the raw bytes in the data's buffer
		data.withUnsafeBytes({ (bytes: UnsafeRawBufferPointer) -> Void in
			let buffer: UnsafePointer<UInt8> = bytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
			let from = buffer + offset
			memcpy(&swapped, from, byteCount)
		})

		//

		payload = CFConvertDoubleSwappedToHost(swapped)
		
		return byteCount
	}
	
	// support for uuid_t

	@discardableResult
	public static func encode(payload: uuid_t, into data: inout Data) throws -> Int
	{
		// use reflection to convert a tuple into an array
		let uuidBytes = Mirror(reflecting: payload).children.map({$0.1 as! UInt8})

		data.append(contentsOf: uuidBytes)
		
		return uuidBytes.count
	}

	@discardableResult
	public static func decode(_ data: Data, at offset: Int, into payload: inout uuid_t) throws -> Int
	{
		// use reflection to count a tuple
		let byteCount = Int(Mirror(reflecting: payload).children.count)
		
		if offset + byteCount > data.count
		{
			throw DecodingError.prematureEndOfData
		}

		// access the raw bytes in the data's buffer
		data.withUnsafeBytes({ (bytes: UnsafeRawBufferPointer) -> Void in
			let buffer: UnsafePointer<UInt8> = bytes.baseAddress!.assumingMemoryBound(to: UInt8.self)
			let from = buffer + offset
			// access the raw bytes in the tuple's buffer
			_ = withUnsafeMutablePointer(to: &payload) { memcpy($0, from, byteCount) }
		})

		return byteCount
	}
}
