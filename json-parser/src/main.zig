const std = @import("std");
const fs = std.fs;
const print = std.debug.print;

const NodeErrors = error{
    InvalidStructure
};

const Node = struct {
    node: Node,
    nodeError: NodeErrors
};

pub fn buildTree(c: u8) !void {
    print("char: {c}", .{c});
    print("\n", .{});
    if(c == '{') {
        print("otiwerajacy nawiaz {c}", .{c});
        print("\n", .{});
    }
}

pub fn openFile(allocator: std.mem.Allocator) ![]u8 {
    // Open the file
    const file = try fs.cwd().openFile("./test.json", .{});
    defer file.close();

    // Get the file size
    const file_size = try file.getEndPos();

    // Create a buffer to hold the entire file content
    var buffer = try allocator.alloc(u8, file_size);

    // Read the entire file into the buffer
    const bytes_read = try file.readAll(buffer);

    // If we didn't read the whole file, resize the buffer
    if (bytes_read < file_size) {
        buffer = try allocator.realloc(buffer, bytes_read);
    }

    return buffer;
}

pub fn main() !void {
    // In your main function or wherever you're using it:
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const file_contents = try openFile(allocator);
    defer allocator.free(file_contents); // Don't forget to free the memory
    print("Data: {s}", .{file_contents});

}
