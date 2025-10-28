-- CreateTable
CREATE TABLE `staff_attendance` (
    `id` VARCHAR(191) NOT NULL,
    `staffId` INTEGER NOT NULL,
    `date` DATETIME(3) NOT NULL,
    `shiftType` ENUM('DAY', 'NIGHT') NOT NULL,
    `status` ENUM('PRESENT', 'ABSENT', 'LATE', 'ON_LEAVE') NOT NULL DEFAULT 'PRESENT',
    `checkInTime` DATETIME(3) NULL,
    `checkOutTime` DATETIME(3) NULL,
    `remarks` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `staff_attendance_staffId_idx`(`staffId`),
    INDEX `staff_attendance_date_idx`(`date`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `staff_attendance` ADD CONSTRAINT `staff_attendance_staffId_fkey` FOREIGN KEY (`staffId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;
