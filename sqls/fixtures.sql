SET client_min_messages TO WARNING;

TRUNCATE public.folders;

INSERT INTO public.folders (id, name, position, parent_id) VALUES
    (1, 'folder_a', 1, NULL),
        (2, 'folder_aa', 1, 1),
            (3, 'folder_aaa', 1, 2),
            (4, 'folder_aab', 2, 2),
            (5, 'folder_aac', 3, 2),
        (6, 'folder_ab', 2, 1),
        (7, 'folder_ac', 3, 1),
        (8, 'folder_ad', 4, 1),
            (9, 'folder_ada', 1, 8),
                (10, 'folder_adaa', 1, 9),
                (11, 'folder_adab', 2, 9),
            (12, 'folder_adb', 2, 8),
            (13, 'folder_adc', 3, 8),
        (14, 'folder_ae', 5, 1),
        (15, 'folder_af', 6, 1),
    (16, 'folder_b', 2, NULL),
        (17, 'folder_ba', 1, 16),
            (18, 'folder_baa', 1, 17),
            (19, 'folder_bab', 2, 17),
            (20, 'folder_bac', 3, 17);

