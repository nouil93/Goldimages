#!/usr/bin/env bash
#
# ==============================================================================
#  Bootstrap Script - Nutanix AHV Image Preparation
# ==============================================================================
#
#  Author: Frédéric Delacour
#  Project: GoldImages
#  Description:
#    Prepares a Linux disk image for Nutanix AHV by running sysprep/customize
#    operations and producing a compact QCOW2 image, with optional RAW export
#    for direct AHV-oriented import workflows.
#
#  Usage:
#    ./bootstrap-nutanix.sh <vm_name>
#
#  Example:
#    ./bootstrap-nutanix.sh rocky-9.6-ahv.qcow2
#
# ==============================================================================

set -euo pipefail
set -x

VM_NAME="${1:?Usage: $0 <vm_name>}"
BUILD_DIR="build"
TMP_DIR="${TMP_DIR:-/var/tmp}"
EXPORT_RAW="${EXPORT_RAW:-0}"

echo "Post Processor Nutanix AHV for ${VM_NAME}"

mkdir -p "${BUILD_DIR}"
cd "${BUILD_DIR}"

test -f "${VM_NAME}"

echo "virt-sysprep..."
sudo /usr/bin/virt-sysprep \
  --operations defaults,-ssh-userdir,-ssh-hostkeys,-lvm-uuids \
  --add "${VM_NAME}"

echo "virt-customize..."
sudo /usr/bin/virt-customize \
  --uninstall ansible \
  --add "${VM_NAME}"

echo "virt-sparsify -> qcow2..."
QCOW2_OUT="${VM_NAME%.qcow2}-nutanix.qcow2"

sudo /usr/bin/virt-sparsify \
  --tmp "${TMP_DIR}" \
  --compress \
  --machine-readable \
  "${VM_NAME}" "${QCOW2_OUT}"

sudo chown "$(id -u):$(id -g)" "${QCOW2_OUT}"

if [[ "${EXPORT_RAW}" == "1" ]]; then
  echo "qemu-img convert -> raw..."
  RAW_OUT="${VM_NAME%.qcow2}-nutanix.raw"
  qemu-img convert -p -f qcow2 -O raw "${QCOW2_OUT}" "${RAW_OUT}"
  echo "Generated RAW image: ${BUILD_DIR}/${RAW_OUT}"
fi

echo "Generated QCOW2 image: ${BUILD_DIR}/${QCOW2_OUT}"