const std = @import("std");
const print = std.debug.print;
const process = std.process;
const io = std.io;

const Operation = enum {
    addition,
    subtraction,
    multiplication,
    division,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try process.argsAlloc(allocator);
    defer process.argsFree(allocator, args);

    if (args.len < 4) {
        print("Usage: calculator <num1> <operation> <num2>\n", .{});
        return;
    }

    const num1 = try parseNumber(args[1]);
    const num2 = try parseNumber(args[3]);
    const operation = try parseOperation(args[2]);

    const result = switch (operation) {
        .addition => num1 + num2,
        .subtraction => num1 - num2,
        .multiplication => num1 * num2,
        .division => blk: {
            if (num2 == 0) {
                print("Error: Division by zero\n", .{});
                return;
            }
            break :blk @divTrunc(num1, num2);
        },
    };

    print("{} {s} {} = {}\n", .{ num1, args[2], num2, result });
}

fn parseNumber(arg: []const u8) !i32 {
    return std.fmt.parseInt(i32, arg, 10) catch |err| {
        print("Error parsing number '{s}': {any}\n", .{ arg, err });
        return err;
    };
}

fn parseOperation(arg: []const u8) !Operation {
    return switch (arg[0]) {
        '+' => .addition,
        '-' => .subtraction,
        '*' => .multiplication,
        '/' => .division,
        else => {
            print("Invalid operation. Use: +, -, *, /\n", .{});
            return error.InvalidOperation;
        },
    };
}
