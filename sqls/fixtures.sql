\echo "Loading fixtures..."

SET client_min_messages TO WARNING;

TRUNCATE public.folders;

INSERT INTO public.folders (id, name, position, parent_id) VALUES
    (1, 'folder_a', 1, NULL),
        (2, 'folder_aa', 1, 1),
            (3, 'folder_aaa', 1, 2),
            (4, 'folder_aab', 2, 2),
            (5, 'folder_aac', 3, 2),
        (6, 'folder_ab', 2, 1),
        (7, 'folder_ac', 3, 1);

\echo "Fixtures loaded"
