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

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const file = try fs.cwd().openFile("./test.json", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const reader = buf_reader.reader();

    var line = std.ArrayList(u8).init(allocator);
    defer line.deinit();

    const writer = line.writer();
    var line_no: usize = 0;
    while (reader.streamUntilDelimiter(writer, '\n', null)) {
        defer line.clearRetainingCapacity();
        line_no += 1;
        for (line.items) |char| {
            try buildTree(char);
        }
    } else |err| switch (err) {
        error.EndOfStream => {
            print("End of stream {any}", .{err});

        },
        else => return err,
    }

    print("Total lines: {d}\n", .{line_no});
}
