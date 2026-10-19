use std::path::PathBuf;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let manifest = PathBuf::from(std::env::var("CARGO_MANIFEST_DIR")?);
    let proto_root = manifest.join("../proto");
    let proto_files = [
        proto_root.join("psychoscope/v1/ipc.proto"),
        proto_root.join("psychoscope/v1/control.proto"),
    ];

    // protoc vendorizado: consumidores nao precisam ter protoc instalado.
    // SAFETY: build scripts sao single-threaded neste ponto.
    unsafe { std::env::set_var("PROTOC", protoc_bin_vendored::protoc_bin_path()?) };

    prost_build::Config::new().compile_protos(
        &proto_files,
        &[proto_root, protoc_bin_vendored::include_path()?],
    )?;
    for f in &proto_files {
        println!("cargo:rerun-if-changed={}", f.display());
    }
    Ok(())
}
