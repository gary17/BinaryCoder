import Foundation

struct TestCase
{
	let number: Double
	let id: UUID = UUID()
}

let testCases: [TestCase] = [

	TestCase(number: -1 * Double.greatestFiniteMagnitude),
	TestCase(number: -1),
	TestCase(number: 0),
	TestCase(number: 1),
	TestCase(number: Double.greatestFiniteMagnitude)
]

var data = Data()

// in

for testCase in testCases
{
	// 1 of 2: encode Double
	
	do
	{
		try BinaryCoder.encode(payload: testCase.number, into: /* in/out */ &data)
	}
	catch
	{
		fatalError("encode failure")
	}
	
	// 2 of 2: alternate encode with uuid_t

	do
	{
		try BinaryCoder.encode(payload: testCase.id.uuid, into: /* in/out */ &data)
	}
	catch
	{
		fatalError("encode failure")
	}
}

// out

var offset: Int = 0

for testCase in testCases
{
	// 1 of 2: decode as Double
	
	do
	{
		// a random Double between 0.0 and 1.0
		var rhs = drand48()
		
		let byteCountOut: Int

		do
		{
			byteCountOut = try BinaryCoder.decode(data, at: offset, into: /* in/out */ &rhs)
		}
		catch
		{
			fatalError("decode failure")
		}

		assert(byteCountOut > 0) // MemoryLayout<Double>.size is an implementation detail, ignore
		offset = offset + byteCountOut

		assert(rhs == testCase.number)
	}
	
	// 2 of 2: decode as uuid_t
	
	do
	{
		var rhs: uuid_t = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
		
		let byteCountOut: Int
		
		do
		{
			byteCountOut = try BinaryCoder.decode(data, at: offset, into: /* in/out */ &rhs)
		}
		catch
		{
			fatalError("decode failure")
		}
		
		assert(byteCountOut > 0) // the exact byte count is an implementation detail, ignore
		offset = offset + byteCountOut

		assert(UUID(uuid: rhs) == testCase.id)
	}
}
