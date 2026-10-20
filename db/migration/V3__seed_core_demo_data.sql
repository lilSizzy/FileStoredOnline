-- V3: Seed Data chuẩn phục vụ Demo Core
INSERT INTO roles (role_name, description) VALUES
    ('ADMIN', 'Quản trị hệ thống toàn quyền'),
    ('MANAGER', 'Quản lý hồ sơ, phê duyệt và xem thống kê'),
    ('MEMBER', 'Cán bộ nghiệp vụ tra cứu, tải lên và cập nhật văn bản'),
    ('GUEST', 'Tài khoản khách chỉ xem văn bản được cấp quyền')
ON CONFLICT (role_name) DO NOTHING;

INSERT INTO users (username, password_hash, email) VALUES
    ('admin_edms', '$2a$10$DemoHashAdmin123456789012345678901234567890', 'admin@edms.vn'),
    ('manager_hieu', '$2a$10$DemoHashManager12345678901234567890123456', 'manager@edms.vn'),
    ('member_minh', '$2a$10$DemoHashMember123456789012345678901234567', 'member@edms.vn'),
    ('guest_user', '$2a$10$DemoHashGuest12345678901234567890123456789', 'guest@edms.vn')
ON CONFLICT (username) DO NOTHING;

INSERT INTO user_roles (user_id, role_id) VALUES
    (1, 1), (2, 2), (3, 3), (4, 4)
ON CONFLICT DO NOTHING;

INSERT INTO documents (title, file_path, file_size, mime_type, uploaded_by, status, current_version_num)
VALUES (
    'Quyết định ban hành Quy chế Lưu trữ điện tử 2026',
    '/app/uploads/docs/doc_1/v2_QD_LuuTru_2026.pdf',
    245760,
    'application/pdf',
    1,
    'ACTIVE',
    2
) ON CONFLICT (file_path) DO NOTHING;

INSERT INTO document_versions (document_id, version_number, file_path, file_size, sha256_hash, change_note, created_by)
VALUES
    (1, 1, '/app/uploads/docs/doc_1/v1_QD_LuuTru_2026.pdf', 204800, 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', 'Bản dự thảo lần 1', 1),
    (1, 2, '/app/uploads/docs/doc_1/v2_QD_LuuTru_2026.pdf', 245760, '8f434346648f6b96df89dda901c5176b10a6d83961dd3c1ac88b59b2dc327aa4', 'Cập nhật phụ lục ký số chính thức', 2)
ON CONFLICT (document_id, version_number) DO NOTHING;

INSERT INTO document_metadata (document_id, meta_key, meta_value) VALUES
    (1, 'so_ky_hieu', '109/QĐ-EDMS'),
    (1, 'co_quan_ban_hanh', 'Hội đồng Quản trị'),
    (1, 'nam_luu_tru', '2026');

INSERT INTO document_permissions (document_id, role_id, permission_type, granted_by) VALUES
    (1, 1, 'MANAGE', 1),
    (1, 2, 'WRITE', 1),
    (1, 3, 'READ', 1);