<?php

namespace App\Http\Controllers\Agent;

use App\Http\Controllers\Controller;
use App\Models\AgentProfit;
use Illuminate\Http\Response;

class ProfitsController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return Response
     */
    public function index($slug = null)
    {

        $profits = AgentProfit::agentAuth()->orderByDesc('id')->paginate(12);
        $page_title = __('Profits Log');

        return view('agent.sections.transaction.log', compact('page_title', 'profits'));
    }
}
