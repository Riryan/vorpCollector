CREATE TABLE `collectables` (
    `identifier` VARCHAR(255),
    `xp`  int(11) NOT NULL,
    `cards` text NOT NULL,
    `coins` text NOT NULL,
    `jewelery` text NOT NULL,
    `eggs` text NOT NULL,
    `flower` text NOT NULL,
    `arrowheads` text NOT NULL,
    `bottles` text NOT NULL
);

--
-- Indexes for table `collectables`
--
ALTER TABLE `collectables`
ADD PRIMARY KEY (`identifier`);