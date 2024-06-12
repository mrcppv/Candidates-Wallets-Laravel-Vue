<?php
namespace App\Http\Controllers;

use App\Mail\CandidateContacted;
use App\Mail\CandidateHired as CandidateHiredMail;
use Illuminate\Support\Facades\Mail;
use App\Models\Candidate;
use App\Models\Company;
use App\Events\CandidateHired;

class CandidateController extends Controller
{
    public function index()
    {
        $candidates = Candidate::all();
        $coins = Company::find(1)->coins;
        return view('candidates.index', compact('candidates', 'coins'));
    }

    public function contact($candidateId)
    {
        $candidate = Candidate::find($candidateId);
        $company = Company::find(1);
        $coins = $company->coins;
        $contactedby = $candidate->contactedby;

        if ($coins >= 5) {
            if ($contactedby == 1) {
                return response()->json([
                    'message' => 'Error: You have already contacted this candidate!',
                    'coins' => $company->coins // Send updated coins value to the client
                ], 200);
            } else {
                $company->increment('coins', 5);
                $candidate->contactedby = 1;
                $candidate->save();

                // Mail::to($candidate->email)->send(new CandidateContacted($candidate));

                return response()->json([
                    'message' => 'Mail Sent. Candidate Contacted.',
                    'coins' => $company->coins // Send updated coins value to the client

                ], 200);
            }
        } else {
            return response()->json([
                'message' => 'Insufficient funds.',
                'coins' => $company->coins // Send updated coins value to the client

            ]);
        }
    }

    public function coins(){

        $company = Company::find(1);

        return response()->json([
            'coins' => $company->coins // Send updated coins value to the client
        ], 200);
    }

    public function hire($candidateId)
    {
        $candidate = Candidate::find($candidateId);
        $company = Company::find(1);

        if ($candidate->hired !== 1) {
            if ($candidate->contactedby === 1) {
                $company->hireCandidate($candidateId);

                // Increment coins and save candidate status
                $company->increment('coins', 5);
                $candidate->save();


                // Mail::to($candidate->email)->send(new CandidateHiredMail($candidate));

                return response()->json([
                    'message' => 'Candidate hired successfully!',
                    'coins' => $company->coins // Send updated coins value to the client
                ], 200);
            } else {
                return response()->json([
                    'message' => 'Error: You have not contacted this candidate yet!',
                    'coins' => $company->coins // Send updated coins value to the client
                ], 200);
            }
        } else {
            return response()->json([
                'message' => 'Error: This candidate is already hired!',
                'coins' => $company->coins // Send updated coins value to the client
            ], 200);
        }
    }
}
