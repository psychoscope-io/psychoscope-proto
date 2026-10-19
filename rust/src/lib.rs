//! Contrato IPC canonico do Psychoscope (`psychoscope.v1`).
//!
//! Codigo gerado por `prost` a partir de `proto/psychoscope/v1/ipc.proto`.
#![allow(clippy::doc_lazy_continuation)]

pub mod v1 {
    include!(concat!(env!("OUT_DIR"), "/psychoscope.v1.rs"));
}

/// Tamanho maximo de payload de um frame (1 MiB).
pub const MAX_FRAME_SIZE: u32 = 1 << 20;
