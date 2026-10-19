use std::path::PathBuf;

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let manifest = PathBuf::from(std::env::var("CARGO_MANIFEST_DIR")?);
    let proto_root = manifest.join("../proto");
    let proto_file = proto_root.join("psychoscope/v1/ipc.proto");

    // protoc vendorizado: consumidores nao precisam ter protoc instalado.
    // SAFETY: build scripts sao single-threaded neste ponto.
    unsafe { std::env::set_var("PROTOC", protoc_bin_vendored::protoc_bin_path()?) };

    prost_build::Config::new().compile_protos(
        &[&proto_file],
        &[proto_root, protoc_bin_vendored::include_path()?],
    )?;
    println!("cargo:rerun-if-changed={}", proto_file.display());
    Ok(())
}
