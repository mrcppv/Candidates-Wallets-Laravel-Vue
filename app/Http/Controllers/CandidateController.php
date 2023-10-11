<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use App\Mail\CandidateContacted;
use Illuminate\Support\Facades\Mail;
use App\Models\Candidate;
use App\Models\Company;

class CandidateController extends Controller
{
    public function index(){
    $candidates = Candidate::all();
    $coins = Company::find(1)->coins;
    return view('candidates.index', compact('candidates', 'coins'));
    }

    public function contact($candidateId)
    {


        $candidate = Candidate::find($candidateId);
        // Get the company by its ID (assuming company ID is always 1)
        $company = Company::find(1);
        // Check if the company has enough coins
        $coins = $company->coins;
        $contactedby = $candidate->contactedby;



        if ($coins >= 5) {
            if ($contactedby == 1) {
                return response()->json([
                    'message' => 'Error: You have already contacted this candidate!'
                ], 200);
            } else {
                // Deduct 5 coins from the company's wallet and set the contact status to true.
                $company->decrement('coins', 5);
                $candidate->contactedby = 1;
                $candidate->save();
                return response()->json([
                    'message' => 'Mail Sent. Candidate Contacted.'
                ], 200);
            }
            // Send an email to the candidate
            //Mail::to($candidate->email)->send(new CandidateContacted($candidate)); // Pass the candidate to the Mailable

            // Deduct 5 coins from the company's wallet


            // Handle the contact action and email sending here



        } else {

            // Handle the case of insufficient funds
            // You can redirect or show an error message
            return response()->json([
                'message' => 'Insufficient funds.'
            ], 200);

        }



    }





    public function hire($candidateId)
    {

        $candidate = Candidate::find($candidateId);
        $company = Company::find(1);


        if ($candidate->hired !== 1 && $candidate->contactedby === 1) {
            $company->hireCandidate($candidateId);
            // The candidate has been hired.
            $company->increment('coins', 5);
            $candidate->save();
            return response()->json([
                'message' => 'Mail Sent. Candidate Hired.'
            ], 200);

            // Add 5 coins to the total

            //send email


        } else {
            return response()->json([
                'message' => 'Error: You have not contacted this candidate yet!'
            ], 200);
            // The candidate has not been hired.
        }


    }
}
