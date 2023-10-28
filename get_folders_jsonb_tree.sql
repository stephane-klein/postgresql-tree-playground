WITH RECURSIVE _folders_with_level AS (
    SELECT
        *,
        0 AS lvl
    FROM   folders
    WHERE  parent_id IS NULL

    UNION ALL

    SELECT _child.*, _parent.lvl + 1
    FROM   folders _child
    JOIN   _folders_with_level _parent ON _parent.id = _child.parent_id
),
_maxlvl AS (
  SELECT max(lvl) _maxlvl FROM _folders_with_level
),
_folders_tree AS (
    SELECT
        _folders_with_level.*,
        JSONB '[]' AS children
    FROM
        _folders_with_level,
        _maxlvl
    WHERE  lvl = _maxlvl

    UNION
    (
        SELECT
            (_branch_parent).*,
            JSONB_AGG(_branch_child)
        FROM (
            SELECT
                _branch_parent,
                _branch_child
            FROM
                _folders_with_level _branch_parent
            JOIN
                _folders_tree _branch_child ON _branch_child.parent_id = _branch_parent.id
        ) _branch
        GROUP BY _branch._branch_parent

        UNION

        SELECT
            _folders_with_level.*,
            JSONB '[]' AS children
        FROM   _folders_with_level
        WHERE  NOT EXISTS (
            SELECT 1
            FROM _folders_with_level _hypothetical_child
            WHERE _hypothetical_child.parent_id = _folders_with_level.id
        )
    )
)
    SELECT JSONB_PRETTY(ROW_TO_JSON(_folders_tree)::JSONB)
    FROM _folders_tree
    WHERE lvl = 0;
