-- V2: Mở rộng Document Versioning & Phân quyền chi tiết ACL (Đợt 3)
ALTER TABLE documents
    ADD COLUMN IF NOT EXISTS status VARCHAR(30) NOT NULL DEFAULT 'ACTIVE'
        CHECK (status IN ('DRAFT', 'ACTIVE', 'ARCHIVED', 'DELETED')),
    ADD COLUMN IF NOT EXISTS current_version_num INT NOT NULL DEFAULT 1
        CHECK (current_version_num >= 1);

CREATE TABLE IF NOT EXISTS document_versions (
    id BIGSERIAL PRIMARY KEY,
    document_id BIGINT NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    version_number INT NOT NULL CHECK (version_number >= 1),
    file_path VARCHAR(500) NOT NULL UNIQUE,
    file_size BIGINT NOT NULL CHECK (file_size >= 0),
    sha256_hash VARCHAR(64) NOT NULL,
    change_note VARCHAR(500),
    created_by BIGINT NOT NULL REFERENCES users(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT uq_doc_version UNIQUE (document_id, version_number)
);

CREATE TABLE IF NOT EXISTS document_permissions (
    id BIGSERIAL PRIMARY KEY,
    document_id BIGINT NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id) ON DELETE CASCADE,
    role_id INT REFERENCES roles(id) ON DELETE CASCADE,
    permission_type VARCHAR(30) NOT NULL CHECK (permission_type IN ('READ','WRITE','DELETE','MANAGE')),
    granted_by BIGINT NOT NULL REFERENCES users(id),
    granted_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT chk_principal_target CHECK (
        (user_id IS NOT NULL AND role_id IS NULL) OR
        (user_id IS NULL AND role_id IS NOT NULL)
    )
);

CREATE INDEX IF NOT EXISTS idx_doc_versions_doc_id ON document_versions(document_id, version_number DESC);
CREATE INDEX IF NOT EXISTS idx_doc_perms_lookup ON document_permissions(document_id, user_id, role_id);