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


TRUNCATE public.ltree_folders;

INSERT INTO public.ltree_folders (path, name) VALUES
    ('1',       'folder_a'),
    ('1.1',     'folder_aa'),
    ('1.1.1',   'folder_aaa'),
    ('1.1.2',   'folder_aab'),
    ('1.1.3',   'folder_aac'),
    ('1.2',     'folder_ab'),
    ('1.3',     'folder_ac'),
    ('1.4',     'folder_ad'),
    ('1.4.1',   'folder_ada'),
    ('1.4.2',   'folder_adb'),
    ('1.4.3',   'folder_adc'),
    ('1.4.3.1', 'folder_adca'),
    ('2',       'folder_b'),
    ('2.1',     'folder_ba'),
    ('2.2',     'folder_bb'),
    ('2.2.1',   'folder_bba');
