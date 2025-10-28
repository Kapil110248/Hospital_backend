-- CreateTable
CREATE TABLE `User` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `email` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `role` ENUM('SYSTEM_ADMIN', 'DOCTOR', 'NURSE', 'RECEPTIONIST', 'PHARMACIST', 'LAB_TECH', 'RADIOLOGIST', 'ACCOUNTANT', 'AUDITOR', 'PATIENT', 'OTHER') NOT NULL,
    `displayName` VARCHAR(191) NULL,
    `phone` VARCHAR(191) NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `createdById` INTEGER NULL,
    `updatedById` INTEGER NULL,

    UNIQUE INDEX `User_email_key`(`email`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `AuditLog` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `entity` VARCHAR(191) NOT NULL,
    `entityId` INTEGER NULL,
    `action` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `performedBy` INTEGER NULL,
    `metadata` JSON NULL,
    `ipAddress` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Department` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `code` VARCHAR(191) NULL,
    `description` VARCHAR(191) NULL,
    `type` ENUM('CLINICAL', 'NON_CLINICAL', 'SUPPORT', 'ADMIN') NOT NULL DEFAULT 'CLINICAL',
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Department_code_key`(`code`),
    INDEX `Department_name_idx`(`name`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Patient` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userId` INTEGER NULL,
    `mrn` VARCHAR(191) NULL,
    `firstName` VARCHAR(191) NOT NULL,
    `lastName` VARCHAR(191) NOT NULL,
    `gender` ENUM('MALE', 'FEMALE', 'OTHER', 'UNKNOWN') NULL,
    `dateOfBirth` DATETIME(3) NULL,
    `contactNumber` VARCHAR(191) NULL,
    `email` VARCHAR(191) NULL,
    `address` VARCHAR(191) NULL,
    `emergencyName` VARCHAR(191) NULL,
    `emergencyPhone` VARCHAR(191) NULL,
    `insuranceInfo` JSON NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `isDeleted` BOOLEAN NOT NULL DEFAULT false,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Patient_userId_key`(`userId`),
    UNIQUE INDEX `Patient_mrn_key`(`mrn`),
    INDEX `Patient_lastName_firstName_idx`(`lastName`, `firstName`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Doctor` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userId` INTEGER NULL,
    `doctorCode` VARCHAR(191) NOT NULL,
    `referralCodeId` INTEGER NULL,
    `firstName` VARCHAR(191) NOT NULL,
    `lastName` VARCHAR(191) NOT NULL,
    `speciality` VARCHAR(191) NULL,
    `departmentId` INTEGER NULL,
    `qualifications` VARCHAR(191) NULL,
    `contactNumber` VARCHAR(191) NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Doctor_userId_key`(`userId`),
    UNIQUE INDEX `Doctor_doctorCode_key`(`doctorCode`),
    INDEX `Doctor_lastName_firstName_doctorCode_idx`(`lastName`, `firstName`, `doctorCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Nurse` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userId` INTEGER NULL,
    `firstName` VARCHAR(191) NOT NULL,
    `lastName` VARCHAR(191) NOT NULL,
    `ward` VARCHAR(191) NULL,
    `contact` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `Nurse_userId_key`(`userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Pharmacist` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `userId` INTEGER NULL,
    `firstName` VARCHAR(191) NOT NULL,
    `lastName` VARCHAR(191) NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `Pharmacist_userId_key`(`userId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Room` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `departmentId` INTEGER NULL,
    `name` VARCHAR(191) NOT NULL,
    `floor` VARCHAR(191) NULL,
    `type` VARCHAR(191) NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Bed` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `roomId` INTEGER NOT NULL,
    `bedNumber` VARCHAR(191) NOT NULL,
    `isOccupied` BOOLEAN NOT NULL DEFAULT false,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Admission` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `patientId` INTEGER NOT NULL,
    `admittedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dischargedAt` DATETIME(3) NULL,
    `admissionType` VARCHAR(191) NULL,
    `roomId` INTEGER NULL,
    `bedId` INTEGER NULL,
    `admittingDoctorId` INTEGER NULL,
    `notes` VARCHAR(191) NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Appointment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `appointmentNumber` VARCHAR(191) NULL,
    `patientId` INTEGER NOT NULL,
    `doctorId` INTEGER NULL,
    `departmentId` INTEGER NULL,
    `scheduledAt` DATETIME(3) NOT NULL,
    `durationMins` INTEGER NULL,
    `status` ENUM('SCHEDULED', 'CONFIRMED', 'CHECKED_IN', 'IN_CONSULTATION', 'COMPLETED', 'CANCELLED', 'NO_SHOW', 'RESCHEDULED') NOT NULL DEFAULT 'SCHEDULED',
    `reason` VARCHAR(191) NULL,
    `notes` VARCHAR(191) NULL,
    `referralCodeId` INTEGER NULL,
    `checkedInAt` DATETIME(3) NULL,
    `consultedAt` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `isDeleted` BOOLEAN NOT NULL DEFAULT false,

    UNIQUE INDEX `Appointment_appointmentNumber_key`(`appointmentNumber`),
    INDEX `Appointment_patientId_scheduledAt_idx`(`patientId`, `scheduledAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MedicalRecord` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `patientId` INTEGER NOT NULL,
    `title` VARCHAR(191) NULL,
    `description` VARCHAR(191) NULL,
    `attachments` JSON NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `createdById` INTEGER NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `ReferralCode` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `doctorId` INTEGER NOT NULL,
    `code` VARCHAR(191) NOT NULL,
    `description` VARCHAR(191) NULL,
    `isAuto` BOOLEAN NOT NULL DEFAULT true,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `validFrom` DATETIME(3) NULL,
    `validTo` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `ReferralCode_code_key`(`code`),
    INDEX `ReferralCode_doctorId_idx`(`doctorId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CommissionSetup` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `createdById` INTEGER NULL,
    `doctorId` INTEGER NULL,
    `departmentId` INTEGER NULL,
    `referralCodeId` INTEGER NULL,
    `source` ENUM('PHARMACY', 'LAB', 'RADIOLOGY', 'SURGERY', 'BLOOD_BANK', 'CONSULTATION', 'OTHER') NOT NULL,
    `commissionType` ENUM('PERCENTAGE', 'FLAT') NOT NULL DEFAULT 'PERCENTAGE',
    `value` DECIMAL(65, 30) NOT NULL,
    `description` VARCHAR(191) NULL,
    `isActive` BOOLEAN NOT NULL DEFAULT true,
    `validFrom` DATETIME(3) NULL,
    `validTo` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `CommissionSetup_source_doctorId_departmentId_idx`(`source`, `doctorId`, `departmentId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CommissionTransaction` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `referralCodeId` INTEGER NULL,
    `doctorId` INTEGER NOT NULL,
    `sourceType` ENUM('PHARMACY', 'LAB', 'RADIOLOGY', 'SURGERY', 'BLOOD_BANK', 'CONSULTATION', 'OTHER') NOT NULL,
    `sourceId` INTEGER NULL,
    `invoiceId` INTEGER NULL,
    `amount` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `percentage` DECIMAL(65, 30) NULL,
    `commissionType` ENUM('PERCENTAGE', 'FLAT') NOT NULL,
    `status` ENUM('PENDING', 'READY_TO_PAY', 'PAID', 'CANCELLED') NOT NULL DEFAULT 'PENDING',
    `notes` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `paidAt` DATETIME(3) NULL,

    INDEX `CommissionTransaction_doctorId_status_sourceType_idx`(`doctorId`, `status`, `sourceType`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CommissionPayout` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `payoutNumber` VARCHAR(191) NULL,
    `totalAmount` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `issuedAt` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `createdById` INTEGER NULL,
    `notes` VARCHAR(191) NULL,

    UNIQUE INDEX `CommissionPayout_payoutNumber_key`(`payoutNumber`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `CommissionPayoutItem` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `commissionPayoutId` INTEGER NOT NULL,
    `commissionTransactionId` INTEGER NOT NULL,
    `amount` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,

    UNIQUE INDEX `CommissionPayoutItem_commissionTransactionId_key`(`commissionTransactionId`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `DoctorEarning` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `doctorId` INTEGER NOT NULL,
    `amount` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `sourceType` ENUM('PHARMACY', 'LAB', 'RADIOLOGY', 'SURGERY', 'BLOOD_BANK', 'CONSULTATION', 'OTHER') NOT NULL,
    `sourceId` INTEGER NULL,
    `referralCode` VARCHAR(191) NULL,
    `note` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `DoctorEarning_doctorId_sourceType_createdAt_idx`(`doctorId`, `sourceType`, `createdAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Medicine` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(191) NOT NULL,
    `sku` VARCHAR(191) NULL,
    `brand` VARCHAR(191) NULL,
    `description` VARCHAR(191) NULL,
    `unitPrice` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Medicine_sku_key`(`sku`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PharmacyStock` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `medicineId` INTEGER NOT NULL,
    `batchNumber` VARCHAR(191) NULL,
    `expiryDate` DATETIME(3) NULL,
    `quantity` INTEGER NOT NULL,
    `costPrice` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PurchaseOrder` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `poNumber` VARCHAR(191) NULL,
    `supplier` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `PurchaseOrder_poNumber_key`(`poNumber`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PurchaseOrderItem` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `purchaseOrderId` INTEGER NOT NULL,
    `medicineId` INTEGER NOT NULL,
    `quantity` INTEGER NOT NULL,
    `unitPrice` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PharmacySale` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `saleNumber` VARCHAR(191) NULL,
    `prescriptionId` INTEGER NULL,
    `pharmacistId` INTEGER NULL,
    `totalAmount` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `paymentMode` ENUM('CASH', 'FIB', 'CARD', 'INSURANCE', 'NEFT', 'UPI', 'OTHER') NOT NULL,
    `paymentStatus` ENUM('PENDING', 'PAID', 'PARTIAL', 'REFUNDED', 'FAILED') NOT NULL DEFAULT 'PENDING',
    `referralCodeId` INTEGER NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `PharmacySale_saleNumber_key`(`saleNumber`),
    UNIQUE INDEX `PharmacySale_prescriptionId_key`(`prescriptionId`),
    INDEX `PharmacySale_referralCodeId_paymentStatus_idx`(`referralCodeId`, `paymentStatus`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PharmacySaleItem` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `pharmacySaleId` INTEGER NOT NULL,
    `medicineId` INTEGER NOT NULL,
    `quantity` INTEGER NOT NULL,
    `unitPrice` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `totalPrice` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Prescription` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `prescriptionNumber` VARCHAR(191) NULL,
    `patientId` INTEGER NOT NULL,
    `doctorId` INTEGER NULL,
    `appointmentId` INTEGER NULL,
    `issuedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `notes` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,
    `referralCodeId` INTEGER NULL,

    UNIQUE INDEX `Prescription_prescriptionNumber_key`(`prescriptionNumber`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `PrescriptionItem` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `prescriptionId` INTEGER NOT NULL,
    `medicineId` INTEGER NOT NULL,
    `dosage` VARCHAR(191) NULL,
    `quantity` INTEGER NOT NULL,
    `unitPrice` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `totalPrice` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `LabTestTemplate` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `departmentId` INTEGER NULL,
    `price` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `LabTestTemplate_code_key`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `LabRequest` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `requestNumber` VARCHAR(191) NULL,
    `patientId` INTEGER NOT NULL,
    `doctorId` INTEGER NULL,
    `appointmentId` INTEGER NULL,
    `templateId` INTEGER NOT NULL,
    `referralCodeId` INTEGER NULL,
    `status` ENUM('REQUESTED', 'IN_PROCESS', 'COMPLETED', 'CANCELLED', 'REVIEW_PENDING') NOT NULL DEFAULT 'REQUESTED',
    `requestedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `completedAt` DATETIME(3) NULL,
    `resultFileUrl` VARCHAR(191) NULL,
    `resultSummary` VARCHAR(191) NULL,
    `price` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `paymentStatus` ENUM('PENDING', 'PAID', 'PARTIAL', 'REFUNDED', 'FAILED') NOT NULL DEFAULT 'PENDING',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `LabRequest_requestNumber_key`(`requestNumber`),
    INDEX `LabRequest_referralCodeId_status_idx`(`referralCodeId`, `status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `RadiologyTemplate` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `code` VARCHAR(191) NOT NULL,
    `name` VARCHAR(191) NOT NULL,
    `departmentId` INTEGER NULL,
    `price` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `RadiologyTemplate_code_key`(`code`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `RadiologyRequest` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `requestNumber` VARCHAR(191) NULL,
    `patientId` INTEGER NOT NULL,
    `doctorId` INTEGER NULL,
    `appointmentId` INTEGER NULL,
    `templateId` INTEGER NOT NULL,
    `referralCodeId` INTEGER NULL,
    `status` ENUM('REQUESTED', 'IN_PROCESS', 'COMPLETED', 'CANCELLED', 'REVIEW_PENDING') NOT NULL DEFAULT 'REQUESTED',
    `requestedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `completedAt` DATETIME(3) NULL,
    `reportUrl` VARCHAR(191) NULL,
    `findings` VARCHAR(191) NULL,
    `price` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `paymentStatus` ENUM('PENDING', 'PAID', 'PARTIAL', 'REFUNDED', 'FAILED') NOT NULL DEFAULT 'PENDING',

    UNIQUE INDEX `RadiologyRequest_requestNumber_key`(`requestNumber`),
    INDEX `RadiologyRequest_referralCodeId_status_idx`(`referralCodeId`, `status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Surgery` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `surgeryNumber` VARCHAR(191) NULL,
    `patientId` INTEGER NOT NULL,
    `scheduledAt` DATETIME(3) NOT NULL,
    `status` ENUM('SCHEDULED', 'ONGOING', 'COMPLETED', 'CANCELLED', 'POSTPONED') NOT NULL DEFAULT 'SCHEDULED',
    `surgeryType` VARCHAR(191) NULL,
    `operatingRoom` VARCHAR(191) NULL,
    `referralCodeId` INTEGER NULL,
    `notes` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `Surgery_surgeryNumber_key`(`surgeryNumber`),
    INDEX `Surgery_referralCodeId_scheduledAt_idx`(`referralCodeId`, `scheduledAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `SurgeryDoctor` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `surgeryId` INTEGER NOT NULL,
    `doctorId` INTEGER NOT NULL,
    `role` VARCHAR(191) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Invoice` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `invoiceNumber` VARCHAR(191) NOT NULL,
    `invoiceType` ENUM('CONSULTATION', 'LAB', 'RADIOLOGY', 'PHARMACY', 'SURGERY', 'ADMISSION', 'OTHER') NOT NULL,
    `appointmentId` INTEGER NULL,
    `admissionId` INTEGER NULL,
    `pharmacySaleId` INTEGER NULL,
    `labRequestId` INTEGER NULL,
    `radiologyRequestId` INTEGER NULL,
    `surgeryId` INTEGER NULL,
    `patientId` INTEGER NOT NULL,
    `totalAmount` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `paidAmount` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `paymentMode` ENUM('CASH', 'FIB', 'CARD', 'INSURANCE', 'NEFT', 'UPI', 'OTHER') NULL,
    `paymentStatus` ENUM('PENDING', 'PAID', 'PARTIAL', 'REFUNDED', 'FAILED') NOT NULL DEFAULT 'PENDING',
    `issuedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dueAt` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Invoice_invoiceNumber_key`(`invoiceNumber`),
    INDEX `Invoice_patientId_issuedAt_idx`(`patientId`, `issuedAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `InvoiceItem` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `invoiceId` INTEGER NOT NULL,
    `description` VARCHAR(191) NOT NULL,
    `quantity` INTEGER NOT NULL DEFAULT 1,
    `unitPrice` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `total` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Payment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `invoiceId` INTEGER NOT NULL,
    `amount` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `paymentMode` ENUM('CASH', 'FIB', 'CARD', 'INSURANCE', 'NEFT', 'UPI', 'OTHER') NOT NULL,
    `paymentRef` VARCHAR(191) NULL,
    `paidAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `status` ENUM('PENDING', 'PAID', 'PARTIAL', 'REFUNDED', 'FAILED') NOT NULL DEFAULT 'PAID',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Expense` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(191) NOT NULL,
    `amount` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `expenseDate` DATETIME(3) NOT NULL,
    `departmentId` INTEGER NULL,
    `notes` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `DepartmentRevenue` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `departmentId` INTEGER NOT NULL,
    `date` DATETIME(3) NOT NULL,
    `totalAmount` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `MedicationLog` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `patientId` INTEGER NOT NULL,
    `nurseId` INTEGER NOT NULL,
    `medicineId` INTEGER NULL,
    `administeredAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dosage` VARCHAR(191) NULL,
    `notes` VARCHAR(191) NULL,

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `NurseNote` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `patientId` INTEGER NOT NULL,
    `nurseId` INTEGER NOT NULL,
    `note` TEXT NOT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Attachment` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `url` VARCHAR(191) NOT NULL,
    `type` VARCHAR(191) NULL,
    `meta` JSON NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Setting` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `key` VARCHAR(191) NOT NULL,
    `value` VARCHAR(191) NOT NULL,
    `group` VARCHAR(191) NULL,
    `updatedAt` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Setting_key_key`(`key`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `BloodDonor` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `donorCode` VARCHAR(191) NULL,
    `firstName` VARCHAR(191) NOT NULL,
    `lastName` VARCHAR(191) NULL,
    `contact` VARCHAR(191) NULL,
    `bloodType` ENUM('A_POS', 'A_NEG', 'B_POS', 'B_NEG', 'AB_POS', 'AB_NEG', 'O_POS', 'O_NEG', 'UNKNOWN') NOT NULL,
    `lastDonated` DATETIME(3) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `BloodDonor_donorCode_key`(`donorCode`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `BloodInventory` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `donorId` INTEGER NULL,
    `bloodType` ENUM('A_POS', 'A_NEG', 'B_POS', 'B_NEG', 'AB_POS', 'AB_NEG', 'O_POS', 'O_NEG', 'UNKNOWN') NOT NULL,
    `units` INTEGER NOT NULL DEFAULT 1,
    `collectedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `expiryAt` DATETIME(3) NULL,
    `status` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    INDEX `BloodInventory_bloodType_status_idx`(`bloodType`, `status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `BloodRequest` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `requestNumber` VARCHAR(191) NULL,
    `inventoryId` INTEGER NULL,
    `patientId` INTEGER NULL,
    `requestedById` INTEGER NULL,
    `doctorId` INTEGER NULL,
    `referralCodeId` INTEGER NULL,
    `unitsRequested` INTEGER NOT NULL DEFAULT 1,
    `unitsIssued` INTEGER NULL,
    `issueDate` DATETIME(3) NULL,
    `status` VARCHAR(191) NOT NULL DEFAULT 'REQUESTED',
    `commissionAmount` DECIMAL(65, 30) NOT NULL DEFAULT 0.0,
    `notes` VARCHAR(191) NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),

    UNIQUE INDEX `BloodRequest_requestNumber_key`(`requestNumber`),
    INDEX `BloodRequest_doctorId_referralCodeId_status_idx`(`doctorId`, `referralCodeId`, `status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `vitals` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `patientId` INTEGER NOT NULL,
    `admissionId` INTEGER NULL,
    `recordedById` INTEGER NULL,
    `recordedAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `temperature` DECIMAL(5, 2) NULL,
    `pulse` INTEGER NULL,
    `respiration` INTEGER NULL,
    `systolic` INTEGER NULL,
    `diastolic` INTEGER NULL,
    `spo2` INTEGER NULL,
    `weight` DECIMAL(6, 2) NULL,
    `height` DECIMAL(5, 2) NULL,
    `bmi` DECIMAL(5, 2) NULL,
    `painScore` INTEGER NULL,
    `remarks` TEXT NULL,
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `vitals_patientId_idx`(`patientId`),
    INDEX `vitals_admissionId_idx`(`admissionId`),
    INDEX `vitals_recordedAt_idx`(`recordedAt`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `follow_ups` (
    `id` VARCHAR(191) NOT NULL,
    `patientId` INTEGER NOT NULL,
    `doctorId` INTEGER NOT NULL,
    `appointmentId` INTEGER NULL,
    `followUpDate` DATETIME(3) NOT NULL,
    `purpose` ENUM('REVIEW', 'LAB_RESULT', 'PROCEDURE', 'FOLLOW_CHECKUP') NOT NULL,
    `notes` VARCHAR(191) NULL,
    `feedback` VARCHAR(191) NULL,
    `status` ENUM('SCHEDULED', 'COMPLETED', 'MISSED', 'CANCELLED') NOT NULL DEFAULT 'SCHEDULED',
    `createdAt` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updatedAt` DATETIME(3) NOT NULL,

    INDEX `follow_ups_patientId_idx`(`patientId`),
    INDEX `follow_ups_doctorId_idx`(`doctorId`),
    INDEX `follow_ups_followUpDate_idx`(`followUpDate`),
    INDEX `follow_ups_status_idx`(`status`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `User` ADD CONSTRAINT `User_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `User` ADD CONSTRAINT `User_updatedById_fkey` FOREIGN KEY (`updatedById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `AuditLog` ADD CONSTRAINT `AuditLog_performedBy_fkey` FOREIGN KEY (`performedBy`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Patient` ADD CONSTRAINT `Patient_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Doctor` ADD CONSTRAINT `Doctor_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Doctor` ADD CONSTRAINT `Doctor_departmentId_fkey` FOREIGN KEY (`departmentId`) REFERENCES `Department`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Nurse` ADD CONSTRAINT `Nurse_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Pharmacist` ADD CONSTRAINT `Pharmacist_userId_fkey` FOREIGN KEY (`userId`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Room` ADD CONSTRAINT `Room_departmentId_fkey` FOREIGN KEY (`departmentId`) REFERENCES `Department`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Bed` ADD CONSTRAINT `Bed_roomId_fkey` FOREIGN KEY (`roomId`) REFERENCES `Room`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Admission` ADD CONSTRAINT `Admission_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Admission` ADD CONSTRAINT `Admission_roomId_fkey` FOREIGN KEY (`roomId`) REFERENCES `Room`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Admission` ADD CONSTRAINT `Admission_bedId_fkey` FOREIGN KEY (`bedId`) REFERENCES `Bed`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Admission` ADD CONSTRAINT `Admission_admittingDoctorId_fkey` FOREIGN KEY (`admittingDoctorId`) REFERENCES `Doctor`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Appointment` ADD CONSTRAINT `Appointment_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Appointment` ADD CONSTRAINT `Appointment_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `Doctor`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Appointment` ADD CONSTRAINT `Appointment_departmentId_fkey` FOREIGN KEY (`departmentId`) REFERENCES `Department`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Appointment` ADD CONSTRAINT `Appointment_referralCodeId_fkey` FOREIGN KEY (`referralCodeId`) REFERENCES `ReferralCode`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MedicalRecord` ADD CONSTRAINT `MedicalRecord_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MedicalRecord` ADD CONSTRAINT `MedicalRecord_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `ReferralCode` ADD CONSTRAINT `ReferralCode_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `Doctor`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CommissionSetup` ADD CONSTRAINT `CommissionSetup_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CommissionSetup` ADD CONSTRAINT `CommissionSetup_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `Doctor`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CommissionSetup` ADD CONSTRAINT `CommissionSetup_departmentId_fkey` FOREIGN KEY (`departmentId`) REFERENCES `Department`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CommissionSetup` ADD CONSTRAINT `CommissionSetup_referralCodeId_fkey` FOREIGN KEY (`referralCodeId`) REFERENCES `ReferralCode`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CommissionTransaction` ADD CONSTRAINT `CommissionTransaction_referralCodeId_fkey` FOREIGN KEY (`referralCodeId`) REFERENCES `ReferralCode`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CommissionTransaction` ADD CONSTRAINT `CommissionTransaction_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `Doctor`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CommissionTransaction` ADD CONSTRAINT `CommissionTransaction_invoiceId_fkey` FOREIGN KEY (`invoiceId`) REFERENCES `Invoice`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CommissionPayout` ADD CONSTRAINT `CommissionPayout_createdById_fkey` FOREIGN KEY (`createdById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CommissionPayoutItem` ADD CONSTRAINT `CommissionPayoutItem_commissionPayoutId_fkey` FOREIGN KEY (`commissionPayoutId`) REFERENCES `CommissionPayout`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `CommissionPayoutItem` ADD CONSTRAINT `CommissionPayoutItem_commissionTransactionId_fkey` FOREIGN KEY (`commissionTransactionId`) REFERENCES `CommissionTransaction`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `DoctorEarning` ADD CONSTRAINT `DoctorEarning_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `Doctor`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PharmacyStock` ADD CONSTRAINT `PharmacyStock_medicineId_fkey` FOREIGN KEY (`medicineId`) REFERENCES `Medicine`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PurchaseOrderItem` ADD CONSTRAINT `PurchaseOrderItem_purchaseOrderId_fkey` FOREIGN KEY (`purchaseOrderId`) REFERENCES `PurchaseOrder`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PurchaseOrderItem` ADD CONSTRAINT `PurchaseOrderItem_medicineId_fkey` FOREIGN KEY (`medicineId`) REFERENCES `Medicine`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PharmacySale` ADD CONSTRAINT `PharmacySale_prescriptionId_fkey` FOREIGN KEY (`prescriptionId`) REFERENCES `Prescription`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PharmacySale` ADD CONSTRAINT `PharmacySale_pharmacistId_fkey` FOREIGN KEY (`pharmacistId`) REFERENCES `Pharmacist`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PharmacySale` ADD CONSTRAINT `PharmacySale_referralCodeId_fkey` FOREIGN KEY (`referralCodeId`) REFERENCES `ReferralCode`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PharmacySaleItem` ADD CONSTRAINT `PharmacySaleItem_pharmacySaleId_fkey` FOREIGN KEY (`pharmacySaleId`) REFERENCES `PharmacySale`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PharmacySaleItem` ADD CONSTRAINT `PharmacySaleItem_medicineId_fkey` FOREIGN KEY (`medicineId`) REFERENCES `Medicine`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Prescription` ADD CONSTRAINT `Prescription_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Prescription` ADD CONSTRAINT `Prescription_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `Doctor`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Prescription` ADD CONSTRAINT `Prescription_appointmentId_fkey` FOREIGN KEY (`appointmentId`) REFERENCES `Appointment`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Prescription` ADD CONSTRAINT `Prescription_referralCodeId_fkey` FOREIGN KEY (`referralCodeId`) REFERENCES `ReferralCode`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PrescriptionItem` ADD CONSTRAINT `PrescriptionItem_prescriptionId_fkey` FOREIGN KEY (`prescriptionId`) REFERENCES `Prescription`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `PrescriptionItem` ADD CONSTRAINT `PrescriptionItem_medicineId_fkey` FOREIGN KEY (`medicineId`) REFERENCES `Medicine`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LabTestTemplate` ADD CONSTRAINT `LabTestTemplate_departmentId_fkey` FOREIGN KEY (`departmentId`) REFERENCES `Department`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LabRequest` ADD CONSTRAINT `LabRequest_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LabRequest` ADD CONSTRAINT `LabRequest_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `Doctor`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LabRequest` ADD CONSTRAINT `LabRequest_appointmentId_fkey` FOREIGN KEY (`appointmentId`) REFERENCES `Appointment`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LabRequest` ADD CONSTRAINT `LabRequest_templateId_fkey` FOREIGN KEY (`templateId`) REFERENCES `LabTestTemplate`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `LabRequest` ADD CONSTRAINT `LabRequest_referralCodeId_fkey` FOREIGN KEY (`referralCodeId`) REFERENCES `ReferralCode`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RadiologyTemplate` ADD CONSTRAINT `RadiologyTemplate_departmentId_fkey` FOREIGN KEY (`departmentId`) REFERENCES `Department`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RadiologyRequest` ADD CONSTRAINT `RadiologyRequest_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RadiologyRequest` ADD CONSTRAINT `RadiologyRequest_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `Doctor`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RadiologyRequest` ADD CONSTRAINT `RadiologyRequest_appointmentId_fkey` FOREIGN KEY (`appointmentId`) REFERENCES `Appointment`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RadiologyRequest` ADD CONSTRAINT `RadiologyRequest_templateId_fkey` FOREIGN KEY (`templateId`) REFERENCES `RadiologyTemplate`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RadiologyRequest` ADD CONSTRAINT `RadiologyRequest_referralCodeId_fkey` FOREIGN KEY (`referralCodeId`) REFERENCES `ReferralCode`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Surgery` ADD CONSTRAINT `Surgery_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Surgery` ADD CONSTRAINT `Surgery_referralCodeId_fkey` FOREIGN KEY (`referralCodeId`) REFERENCES `ReferralCode`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `SurgeryDoctor` ADD CONSTRAINT `SurgeryDoctor_surgeryId_fkey` FOREIGN KEY (`surgeryId`) REFERENCES `Surgery`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `SurgeryDoctor` ADD CONSTRAINT `SurgeryDoctor_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `Doctor`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Invoice` ADD CONSTRAINT `Invoice_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Invoice` ADD CONSTRAINT `Invoice_appointmentId_fkey` FOREIGN KEY (`appointmentId`) REFERENCES `Appointment`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Invoice` ADD CONSTRAINT `Invoice_admissionId_fkey` FOREIGN KEY (`admissionId`) REFERENCES `Admission`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Invoice` ADD CONSTRAINT `Invoice_pharmacySaleId_fkey` FOREIGN KEY (`pharmacySaleId`) REFERENCES `PharmacySale`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Invoice` ADD CONSTRAINT `Invoice_labRequestId_fkey` FOREIGN KEY (`labRequestId`) REFERENCES `LabRequest`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Invoice` ADD CONSTRAINT `Invoice_radiologyRequestId_fkey` FOREIGN KEY (`radiologyRequestId`) REFERENCES `RadiologyRequest`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Invoice` ADD CONSTRAINT `Invoice_surgeryId_fkey` FOREIGN KEY (`surgeryId`) REFERENCES `Surgery`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `InvoiceItem` ADD CONSTRAINT `InvoiceItem_invoiceId_fkey` FOREIGN KEY (`invoiceId`) REFERENCES `Invoice`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Payment` ADD CONSTRAINT `Payment_invoiceId_fkey` FOREIGN KEY (`invoiceId`) REFERENCES `Invoice`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Expense` ADD CONSTRAINT `Expense_departmentId_fkey` FOREIGN KEY (`departmentId`) REFERENCES `Department`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `DepartmentRevenue` ADD CONSTRAINT `DepartmentRevenue_departmentId_fkey` FOREIGN KEY (`departmentId`) REFERENCES `Department`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MedicationLog` ADD CONSTRAINT `MedicationLog_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MedicationLog` ADD CONSTRAINT `MedicationLog_nurseId_fkey` FOREIGN KEY (`nurseId`) REFERENCES `Nurse`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `MedicationLog` ADD CONSTRAINT `MedicationLog_medicineId_fkey` FOREIGN KEY (`medicineId`) REFERENCES `Medicine`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `NurseNote` ADD CONSTRAINT `NurseNote_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `NurseNote` ADD CONSTRAINT `NurseNote_nurseId_fkey` FOREIGN KEY (`nurseId`) REFERENCES `Nurse`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `BloodInventory` ADD CONSTRAINT `BloodInventory_donorId_fkey` FOREIGN KEY (`donorId`) REFERENCES `BloodDonor`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `BloodRequest` ADD CONSTRAINT `BloodRequest_inventoryId_fkey` FOREIGN KEY (`inventoryId`) REFERENCES `BloodInventory`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `BloodRequest` ADD CONSTRAINT `BloodRequest_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `BloodRequest` ADD CONSTRAINT `BloodRequest_requestedById_fkey` FOREIGN KEY (`requestedById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `BloodRequest` ADD CONSTRAINT `BloodRequest_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `Doctor`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `BloodRequest` ADD CONSTRAINT `BloodRequest_referralCodeId_fkey` FOREIGN KEY (`referralCodeId`) REFERENCES `ReferralCode`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vitals` ADD CONSTRAINT `vitals_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vitals` ADD CONSTRAINT `vitals_admissionId_fkey` FOREIGN KEY (`admissionId`) REFERENCES `Admission`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `vitals` ADD CONSTRAINT `vitals_recordedById_fkey` FOREIGN KEY (`recordedById`) REFERENCES `User`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `follow_ups` ADD CONSTRAINT `follow_ups_patientId_fkey` FOREIGN KEY (`patientId`) REFERENCES `Patient`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `follow_ups` ADD CONSTRAINT `follow_ups_doctorId_fkey` FOREIGN KEY (`doctorId`) REFERENCES `User`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `follow_ups` ADD CONSTRAINT `follow_ups_appointmentId_fkey` FOREIGN KEY (`appointmentId`) REFERENCES `Appointment`(`id`) ON DELETE SET NULL ON UPDATE CASCADE;
