const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const qbe = b.addStaticLibrary("qbe", null);
    qbe.setTarget(target);
    qbe.setBuildMode(mode);
    qbe.addCSourceFiles(&[_][]const u8{
        "./src/qbe/cfg.c",
        "./src/qbe/alias.c",
        "./src/qbe/copy.c",
        "./src/qbe/fold.c",
        "./src/qbe/cfg.c",
        "./src/qbe/gas.c",
        "./src/qbe/live.c",
        "./src/qbe/load.c",
        "./src/qbe/mem.c",
        "./src/qbe/parse.c",
        "./src/qbe/qbe.c",
        "./src/qbe/rega.c",
        "./src/qbe/spill.c",
        "./src/qbe/ssa.c",
        "./src/qbe/util.c",
        "./src/qbe/amd64/emit.c",
        "./src/qbe/amd64/isel.c",
        "./src/qbe/amd64/sysv.c",
        "./src/qbe/amd64/targ.c",
        "./src/qbe/rv64/abi.c",
        "./src/qbe/rv64/emit.c",
        "./src/qbe/rv64/isel.c",
        "./src/qbe/rv64/targ.c",
        "./src/qbe/arm64/abi.c",
        "./src/qbe/arm64/targ.c",
        "./src/qbe/arm64/emit.c",
        "./src/qbe/arm64/isel.c",
    }, &[_][]const u8{
        "-std=c2x",
        "-g",
        "-Werror",
        "-Wall",
        "-Wextra",
        "-O3",
    });
    qbe.addIncludeDir("./src");
    qbe.linkLibC();
    qbe.install();

    const exe = b.addExecutable("qbe", null);
    exe.setTarget(target);
    exe.setBuildMode(mode);
    exe.linkLibrary(qbe);
    exe.addCSourceFiles(
        &[_][]const u8{
            "./src/main.c",
        },
        &[_][]const u8{
            "-std=c2x",
            "-g",
            "-Werror",
            "-Wall",
            "-Wextra",
            "-O3",
        },
    );
    exe.addIncludeDir("./src");
    exe.linkLibC();
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
