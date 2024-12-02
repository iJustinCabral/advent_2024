const std = @import("std");

const INPUT = @embedFile("data/input01.txt");

pub fn main() !void {
    var arena_state = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    std.debug.print("part 1: {}\n", .{try part1(arena, INPUT)});
    std.debug.print("part 2: {}\n", .{try part2(arena, INPUT)});
}

fn part1(allocator: std.mem.Allocator, input: []const u8) !u64 {
    var input_lines = std.mem.tokenizeScalar(u8, input, '\n');

    var left_list = std.ArrayList(u64).init(allocator);
    var right_list = std.ArrayList(u64).init(allocator);

    while (input_lines.next()) |line| {
        var line_parts = std.mem.tokenizeScalar(u8, line, ' ');
        try left_list.append(try std.fmt.parseInt(u64, line_parts.next().?, 10));
        try right_list.append(try std.fmt.parseInt(u64, line_parts.next().?, 10));
    }

    std.sort.pdq(u64, left_list.items, {}, std.sort.asc(u64));
    std.sort.pdq(u64, right_list.items, {}, std.sort.asc(u64));

    var sum: u64 = 0;
    for (left_list.items, right_list.items) |l, r| {
        sum += if (r > l) (r - l) else (l - r);
    }

    return sum;
}

fn part2(allocator: std.mem.Allocator, input: []const u8) !u64 {
    var input_lines = std.mem.tokenizeScalar(u8, input, '\n');

    var left_list = std.ArrayList(u64).init(allocator);
    var right_list = std.ArrayList(u64).init(allocator);

    while (input_lines.next()) |line| {
        var line_parts = std.mem.tokenizeScalar(u8, line, ' ');
        try left_list.append(try std.fmt.parseInt(u64, line_parts.next().?, 10));
        try right_list.append(try std.fmt.parseInt(u64, line_parts.next().?, 10));
    }

    const max = std.sort.max(u64, right_list.items, {}, std.sort.asc(u64)).?;
    var counts = try allocator.alloc(u64, max + 1);
    @memset(counts, 0);

    for (right_list.items) |item| {
        counts[item] += 1;
    }

    var sum: u64 = 0;
    for (left_list.items) |item| {
        if (item < counts.len) {
            sum += item * counts[item];
        }
    }

    return sum;
}

test "part 1 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;

    try std.testing.expectEqual(11, try part1(arena, example_input));
}

test "part 2 example" {
    var arena_state = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena_state.deinit();
    const arena = arena_state.allocator();

    const example_input =
        \\3   4
        \\4   3
        \\2   5
        \\1   3
        \\3   9
        \\3   3
    ;

    try std.testing.expectEqual(31, try part2(arena, example_input));
}
