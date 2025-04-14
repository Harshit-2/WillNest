//
//  DoctorsModel.swift
//  WillNest
//
//  Created by Harshit ‎ on 4/13/25.
//

import UIKit

struct DoctorCategory {
    let id: String
    let title: String
    let icon: String
    let description: String
    let color: UIColor
}

struct Doctor {
    let id: String
    let name: String
    let category: String
    let gender: String
    let experience: String
    let degree: String
    let location: String
    let rating: Double
    let imageUrl: String
    let specializations: [String]
    let availableDays: [String]
}

// MARK: - Networking
class APIService {
    static let shared = APIService()
    
    private let baseURL = "https://api.example.com"
    
    func fetchDoctors(forCategory category: String, completion: @escaping ([Doctor]?, Error?) -> Void) {
        // In a real app, you would make an actual API request here
        // For now, we'll simulate a network delay and return mock data
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let doctors = self.getMockDoctors(forCategory: category)
            DispatchQueue.main.async {
                completion(doctors, nil)
            }
        }
    }
    
    // Mock data for demonstration
    private func getMockDoctors(forCategory category: String) -> [Doctor] {
        var doctors = [Doctor]()
        
        switch category {
        case "Cardiologist":
            doctors = [
                Doctor(id: "c1", name: "Dr. Sarah Johnson", category: "Cardiologist", gender: "Female", experience: "15 years", degree: "MD, FACC", location: "Downtown Medical Center", rating: 4.8, imageUrl: "doctor_sarah", specializations: ["Heart Disease", "Cardiac Surgery"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "c2", name: "Dr. Michael Chen", category: "Cardiologist", gender: "Male", experience: "12 years", degree: "MD, PhD", location: "City Hospital", rating: 4.7, imageUrl: "doctor_michael", specializations: ["Interventional Cardiology", "Heart Failure"], availableDays: ["Tuesday", "Thursday", "Saturday"]),
                Doctor(id: "c3", name: "Dr. Robert Williams", category: "Cardiologist", gender: "Male", experience: "20 years", degree: "MD, FACC", location: "Heart Institute", rating: 4.9, imageUrl: "doctor_robert", specializations: ["Electrophysiology", "Preventive Cardiology"], availableDays: ["Monday", "Thursday", "Friday"])
            ]
        case "Dermatologist":
            doctors = [
                Doctor(id: "d1", name: "Dr. Emily Parker", category: "Dermatologist", gender: "Female", experience: "10 years", degree: "MD, FAAD", location: "Skin Care Clinic", rating: 4.6, imageUrl: "doctor_emily", specializations: ["Cosmetic Dermatology", "Skin Cancer"], availableDays: ["Monday", "Tuesday", "Friday"]),
                Doctor(id: "d2", name: "Dr. David Lee", category: "Dermatologist", gender: "Male", experience: "8 years", degree: "MD", location: "Derma Center", rating: 4.5, imageUrl: "doctor_david", specializations: ["Pediatric Dermatology", "Acne Treatment"], availableDays: ["Wednesday", "Thursday", "Saturday"])
            ]
        case "Neurologist":
            doctors = [
                Doctor(id: "n1", name: "Dr. Jessica Wu", category: "Neurologist", gender: "Female", experience: "14 years", degree: "MD, PhD", location: "Neuro Health Center", rating: 4.9, imageUrl: "doctor_jessica", specializations: ["Stroke", "Epilepsy"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "n2", name: "Dr. James Miller", category: "Neurologist", gender: "Male", experience: "18 years", degree: "MD", location: "Brain & Spine Institute", rating: 4.7, imageUrl: "doctor_james", specializations: ["Multiple Sclerosis", "Headache"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Oncologist":
            doctors = [
                Doctor(id: "o1", name: "Dr. Lisa Thompson", category: "Oncologist", gender: "Female", experience: "16 years", degree: "MD, PhD", location: "Cancer Treatment Center", rating: 4.8, imageUrl: "doctor_lisa", specializations: ["Breast Cancer", "Immunotherapy"], availableDays: ["Monday", "Tuesday", "Thursday"]),
                Doctor(id: "o2", name: "Dr. Thomas Brown", category: "Oncologist", gender: "Male", experience: "22 years", degree: "MD, FASCO", location: "Oncology Institute", rating: 4.9, imageUrl: "doctor_thomas", specializations: ["Lung Cancer", "Clinical Trials"], availableDays: ["Wednesday", "Friday"])
            ]
        case "Family Medicine":
            doctors = [
                Doctor(id: "fm1", name: "Dr. Anna Martinez", category: "Family Medicine", gender: "Female", experience: "12 years", degree: "MD, FAAFP", location: "Family Health Clinic", rating: 4.8, imageUrl: "doctor_anna", specializations: ["Preventive Care", "Chronic Disease Management"], availableDays: ["Monday", "Tuesday", "Thursday"]),
                Doctor(id: "fm2", name: "Dr. John Peterson", category: "Family Medicine", gender: "Male", experience: "9 years", degree: "DO", location: "Community Care Center", rating: 4.6, imageUrl: "doctor_john", specializations: ["Women's Health", "Geriatric Care"], availableDays: ["Wednesday", "Friday", "Saturday"])
            ]
        case "Gastroenterologist":
            doctors = [
                Doctor(id: "g1", name: "Dr. Kevin Park", category: "Gastroenterologist", gender: "Male", experience: "15 years", degree: "MD, FACG", location: "Digestive Health Center", rating: 4.7, imageUrl: "doctor_kevin", specializations: ["IBD", "Endoscopy"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "g2", name: "Dr. Maria Rodriguez", category: "Gastroenterologist", gender: "Female", experience: "13 years", degree: "MD", location: "GI Specialists", rating: 4.5, imageUrl: "doctor_maria", specializations: ["Liver Disease", "GERD"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Obstetrics and Gynaecology":
            doctors = [
                Doctor(id: "og1", name: "Dr. Rachel Kim", category: "Obstetrics and Gynaecology", gender: "Female", experience: "14 years", degree: "MD, FACOG", location: "Women's Health Center", rating: 4.9, imageUrl: "doctor_rachel", specializations: ["Pregnancy", "Gynecologic Surgery"], availableDays: ["Monday", "Tuesday", "Thursday"]),
                Doctor(id: "og2", name: "Dr. Elizabeth Chen", category: "Obstetrics and Gynaecology", gender: "Female", experience: "11 years", degree: "MD", location: "Maternal Care Clinic", rating: 4.7, imageUrl: "doctor_elizabeth", specializations: ["Fertility", "Menopause"], availableDays: ["Wednesday", "Friday"])
            ]
        case "Ophthalmologist":
            doctors = [
                Doctor(id: "op1", name: "Dr. Richard Wilson", category: "Ophthalmologist", gender: "Male", experience: "18 years", degree: "MD, FACS", location: "Vision Care Center", rating: 4.8, imageUrl: "doctor_richard", specializations: ["Cataract Surgery", "Glaucoma"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "op2", name: "Dr. Sarah Johnson", category: "Ophthalmologist", gender: "Female", experience: "12 years", degree: "MD", location: "Eye Institute", rating: 4.6, imageUrl: "doctor_sarah_op", specializations: ["Retina Specialist", "Pediatric Ophthalmology"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Psychiatrist":
            doctors = [
                Doctor(id: "ps1", name: "Dr. David Cohen", category: "Psychiatrist", gender: "Male", experience: "20 years", degree: "MD, PhD", location: "Mental Health Clinic", rating: 4.9, imageUrl: "doctor_david_ps", specializations: ["Depression", "Anxiety Disorders"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "ps2", name: "Dr. Michelle Wong", category: "Psychiatrist", gender: "Female", experience: "15 years", degree: "MD", location: "Behavioral Health Center", rating: 4.7, imageUrl: "doctor_michelle", specializations: ["PTSD", "Bipolar Disorder"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Endocrinologist":
            doctors = [
                Doctor(id: "en1", name: "Dr. James Rodriguez", category: "Endocrinologist", gender: "Male", experience: "14 years", degree: "MD, FACE", location: "Diabetes & Hormone Center", rating: 4.8, imageUrl: "doctor_james_en", specializations: ["Diabetes", "Thyroid Disorders"], availableDays: ["Monday", "Tuesday", "Thursday"]),
                Doctor(id: "en2", name: "Dr. Patricia Lee", category: "Endocrinologist", gender: "Female", experience: "16 years", degree: "MD, PhD", location: "Endocrine Associates", rating: 4.7, imageUrl: "doctor_patricia", specializations: ["Adrenal Disorders", "Pituitary Diseases"], availableDays: ["Wednesday", "Friday"])
            ]
        case "Emergency Medicine":
            doctors = [
                Doctor(id: "em1", name: "Dr. Robert Garcia", category: "Emergency Medicine", gender: "Male", experience: "12 years", degree: "MD, FACEP", location: "City Hospital ER", rating: 4.8, imageUrl: "doctor_robert_em", specializations: ["Trauma", "Critical Care"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "em2", name: "Dr. Laura Williams", category: "Emergency Medicine", gender: "Female", experience: "10 years", degree: "MD", location: "Emergency Medical Center", rating: 4.6, imageUrl: "doctor_laura", specializations: ["Pediatric Emergency", "Disaster Medicine"], availableDays: ["Tuesday", "Thursday", "Saturday"])
            ]
        case "Pediatrician":
            doctors = [
                Doctor(id: "pe1", name: "Dr. Jennifer Taylor", category: "Pediatrician", gender: "Female", experience: "15 years", degree: "MD, FAAP", location: "Children's Health Center", rating: 4.9, imageUrl: "doctor_jennifer", specializations: ["Newborn Care", "Adolescent Medicine"], availableDays: ["Monday", "Tuesday", "Thursday"]),
                Doctor(id: "pe2", name: "Dr. Michael Johnson", category: "Pediatrician", gender: "Male", experience: "13 years", degree: "MD", location: "Pediatric Associates", rating: 4.7, imageUrl: "doctor_michael_pe", specializations: ["Developmental Pediatrics", "Behavioral Issues"], availableDays: ["Wednesday", "Friday"])
            ]
        case "Anesthesiologist":
            doctors = [
                Doctor(id: "an1", name: "Dr. Steven Chen", category: "Anesthesiologist", gender: "Male", experience: "18 years", degree: "MD, FASA", location: "Surgical Center", rating: 4.8, imageUrl: "doctor_steven", specializations: ["General Anesthesia", "Regional Anesthesia"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "an2", name: "Dr. Karen Washington", category: "Anesthesiologist", gender: "Female", experience: "14 years", degree: "MD", location: "Pain Management Center", rating: 4.7, imageUrl: "doctor_karen", specializations: ["Obstetric Anesthesia", "Pain Management"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Geriatrics":
            doctors = [
                Doctor(id: "ge1", name: "Dr. William Harris", category: "Geriatrics", gender: "Male", experience: "22 years", degree: "MD, AGSF", location: "Senior Care Center", rating: 4.9, imageUrl: "doctor_william", specializations: ["Dementia", "Falls Prevention"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "ge2", name: "Dr. Susan Chang", category: "Geriatrics", gender: "Female", experience: "19 years", degree: "MD", location: "Elder Health Associates", rating: 4.8, imageUrl: "doctor_susan", specializations: ["Polypharmacy", "Geriatric Syndromes"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Radiologist":
            doctors = [
                Doctor(id: "ra1", name: "Dr. Mark Thompson", category: "Radiologist", gender: "Male", experience: "16 years", degree: "MD, FACR", location: "Imaging Center", rating: 4.7, imageUrl: "doctor_mark", specializations: ["MRI", "CT Scans"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "ra2", name: "Dr. Christine Lee", category: "Radiologist", gender: "Female", experience: "14 years", degree: "MD", location: "Diagnostic Imaging Associates", rating: 4.6, imageUrl: "doctor_christine", specializations: ["Ultrasound", "Mammography"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Hematologist":
            doctors = [
                Doctor(id: "he1", name: "Dr. Daniel Moore", category: "Hematologist", gender: "Male", experience: "17 years", degree: "MD, PhD", location: "Blood Disorders Center", rating: 4.8, imageUrl: "doctor_daniel", specializations: ["Leukemia", "Anemia"], availableDays: ["Monday", "Tuesday", "Thursday"]),
                Doctor(id: "he2", name: "Dr. Linda Jackson", category: "Hematologist", gender: "Female", experience: "15 years", degree: "MD", location: "Hematology Institute", rating: 4.7, imageUrl: "doctor_linda", specializations: ["Coagulation Disorders", "Transfusion Medicine"], availableDays: ["Wednesday", "Friday"])
            ]
        case "Infectious Disease Physician":
            doctors = [
                Doctor(id: "id1", name: "Dr. Paul Martinez", category: "Infectious Disease Physician", gender: "Male", experience: "19 years", degree: "MD, FIDSA", location: "Infectious Disease Center", rating: 4.8, imageUrl: "doctor_paul", specializations: ["HIV/AIDS", "Travel Medicine"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "id2", name: "Dr. Sophia Kim", category: "Infectious Disease Physician", gender: "Female", experience: "14 years", degree: "MD, MPH", location: "Infection Control Associates", rating: 4.7, imageUrl: "doctor_sophia", specializations: ["Antibiotic Resistance", "Tropical Diseases"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Surgeon":
            doctors = [
                Doctor(id: "su1", name: "Dr. Gregory Wilson", category: "Surgeon", gender: "Male", experience: "21 years", degree: "MD, FACS", location: "Surgical Institute", rating: 4.9, imageUrl: "doctor_gregory", specializations: ["General Surgery", "Minimally Invasive Surgery"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "su2", name: "Dr. Rebecca Taylor", category: "Surgeon", gender: "Female", experience: "16 years", degree: "MD", location: "Advanced Surgical Center", rating: 4.8, imageUrl: "doctor_rebecca", specializations: ["Trauma Surgery", "Colorectal Surgery"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Internal Medicine":
            doctors = [
                Doctor(id: "im1", name: "Dr. Thomas Brooks", category: "Internal Medicine", gender: "Male", experience: "14 years", degree: "MD, FACP", location: "Internal Medicine Associates", rating: 4.7, imageUrl: "doctor_thomas_im", specializations: ["Primary Care", "Chronic Disease Management"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "im2", name: "Dr. Olivia Chen", category: "Internal Medicine", gender: "Female", experience: "11 years", degree: "MD", location: "Adult Primary Care Clinic", rating: 4.6, imageUrl: "doctor_olivia", specializations: ["Preventive Medicine", "Geriatric Care"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Nephrologist":
            doctors = [
                Doctor(id: "ne1", name: "Dr. Andrew Kim", category: "Nephrologist", gender: "Male", experience: "18 years", degree: "MD, FASN", location: "Kidney Care Center", rating: 4.8, imageUrl: "doctor_andrew", specializations: ["Chronic Kidney Disease", "Dialysis"], availableDays: ["Monday", "Tuesday", "Thursday"]),
                Doctor(id: "ne2", name: "Dr. Julia Martinez", category: "Nephrologist", gender: "Female", experience: "15 years", degree: "MD", location: "Renal Associates", rating: 4.7, imageUrl: "doctor_julia", specializations: ["Hypertension", "Transplant Nephrology"], availableDays: ["Wednesday", "Friday"])
            ]
        case "Orthopaedist":
            doctors = [
                Doctor(id: "or1", name: "Dr. Christopher Johnson", category: "Orthopaedist", gender: "Male", experience: "19 years", degree: "MD, FAAOS", location: "Orthopaedic Center", rating: 4.8, imageUrl: "doctor_christopher", specializations: ["Joint Replacement", "Sports Medicine"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "or2", name: "Dr. Michelle Lee", category: "Orthopaedist", gender: "Female", experience: "14 years", degree: "MD", location: "Sports Medicine & Orthopaedics", rating: 4.7, imageUrl: "doctor_michelle_or", specializations: ["Hand Surgery", "Trauma"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Pathologist":
            doctors = [
                Doctor(id: "pa1", name: "Dr. Robert Chen", category: "Pathologist", gender: "Male", experience: "20 years", degree: "MD, FCAP", location: "Laboratory Medicine Center", rating: 4.7, imageUrl: "doctor_robert_pa", specializations: ["Surgical Pathology", "Cytopathology"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "pa2", name: "Dr. Lisa Wang", category: "Pathologist", gender: "Female", experience: "17 years", degree: "MD, PhD", location: "Diagnostic Pathology Associates", rating: 4.6, imageUrl: "doctor_lisa_pa", specializations: ["Hematopathology", "Molecular Pathology"], availableDays: ["Tuesday", "Thursday"])
            ]
        case "Allergist":
            doctors = [
                Doctor(id: "al1", name: "Dr. Eric Thompson", category: "Allergist", gender: "Male", experience: "16 years", degree: "MD, FAAAAI", location: "Allergy & Asthma Center", rating: 4.8, imageUrl: "doctor_eric", specializations: ["Food Allergies", "Asthma Management"], availableDays: ["Monday", "Wednesday", "Friday"]),
                Doctor(id: "al2", name: "Dr. Jessica Park", category: "Allergist", gender: "Female", experience: "13 years", degree: "MD", location: "Allergy Associates", rating: 4.7, imageUrl: "doctor_jessica_al", specializations: ["Immunotherapy", "Drug Allergies"], availableDays: ["Tuesday", "Thursday"])
            ]
        default:
            break
        }
        
        return doctors
    }
}
